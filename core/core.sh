#!/usr/bin/env bash

function di::core::check_requirements() {
	FAIL=0
	if ! type jq > /dev/null; then
		echo ""
		FAIL=1
		di::log::warn "jq is not installed"
		di::log "${TGRN}$ ${TOFF}${TBLD}apt install jq${TOFF} or"
		di::log "${TGRN}$ ${TOFF}${TBLD}brew install jq${TOFF} to install."
	fi

	if ! type docker > /dev/null; then
		echo ""
		FAIL=1
		di::log::warn "docker is not installed"
		di::log "Visit ${TBLD}${TUNL}https://docs.docker.com/get-docker/${TOFF} to install."
	fi

	if ! type caddy > /dev/null; then
		echo ""
		FAIL=1
		di::log::warn "caddy is not installed"
		di::log "${TGRN}$ ${TOFF}${TBLD}apt install caddy${TOFF} or"
		di::log "${TGRN}$ ${TOFF}${TBLD}brew install caddy${TOFF} to install."
	fi

	if [ $FAIL -eq 1 ]; then
		exit 1
	fi
}

function di::core::source_local() {
	local PROJECT_FILE="$(pwd)/.dinein"
	if [ -f $PROJECT_FILE ]; then
		source $PROJECT_FILE
	fi
}

function di::core::create_config_dir() {
	mkdir -p "$DINEIN_CONFIG_DIR/$1"
	echo "$DINEIN_CONFIG_DIR/$1"
}

function di::core::load_plugins() {
	for PLUGIN in $(ls $PLUGIN_DIR); do
	  source "$PLUGIN_DIR/$PLUGIN"
	  PLUGINS+=($PLUGIN_CMD)
	  if [[ "$PLUGIN_SERVICE" == "true" ]]; then
		  SERVICES+=($PLUGIN_CMD)
	  fi
	  if [[ "$PLUGIN_BACKEND" == "true" ]]; then
		  BACKENDS+=($PLUGIN_CMD)
	  fi
	done
}

function di::core::init() {
	if [ -f "$(pwd)/.dinein" ]; then
		di::log "Project file already exists in directory!"
		exit 1
	fi

	di::log ""
	di::log::header "Creating .dinein project file. Edit it and then run 'up'."
	di::log::header "You can see list of services by running 'dinein list'"
	di::log ""
	di::log "  .dinein"

	cat <<-TEMPLATE > ".dinein"
	DINEIN_PROJECT="myproject"
	DINEIN_SERVICES=(mysql redis)
	DINEIN_SITE="my-site.test"
TEMPLATE
}

function di::core::up() {
	if [ ! -f "$(pwd)/.dinein" ]; then
		di::log::warn "Run 'dine init' before upping the services"
		exit 1
	fi;

	di::help::header "${DINEIN_PROJECT}"

	for SERVICE in ${DINEIN_SERVICES[@]}; do
		PLUGIN_INIT="di::${SERVICE}::init"
		if type $PLUGIN_INIT &> /dev/null; then
			$PLUGIN_INIT
		fi
	done
}

function di::core::run() {
	di::core::check_requirements
	di::core::load_plugins
	di::core::source_local

	local CMD=${1:-""}
	local SUB=${2:-""}
	local ARGS=${@:3}

	case "$CMD" in
		"init")
			di::core::init
			;;
		"caddy:start")
			di::site::caddy::start
			;;
		"up")
			di::core::up
			;;
		"down")
			di::help::not_implemented $CMD
			;;
		"ps")
			di::ps ${DINEIN_DOCKER_PREFIX}
			;;
		"list")
			di::log::header "Plugins:"
			for PLUGIN in ${PLUGINS[@]}; do
				di::log $PLUGIN

			done
			;;
		"config")
			di::help::config $SUB $ARGS
			;;
		"help")
			di::help $CMD $SUB
			;;
		"")
			di::help $CMD $SUB
			;;
		*)
			FOUND=0
			for PLUGIN in ${PLUGINS[@]}; do
				if [[ "$PLUGIN" == "$CMD" ]]; then
					FOUND=1
					EXE="di::$PLUGIN::run"
					$EXE $SUB $ARGS
				fi
			done

			if [ $FOUND -eq 0 ]; then
				di::help $CMD $SUB
				di::help::unknown_command $CMD $SUB
			fi
			;;
	esac
}


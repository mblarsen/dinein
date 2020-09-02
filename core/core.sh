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
	  if [[ "$PLUGIN_HOST" == "true" ]]; then
		  HOSTS+=($PLUGIN_CMD)
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
	local PROJECT_FILE="$(pwd)/.dinein"

	case "$CMD" in
		"init")
			if [ -f $PROJECT_FILE ]; then
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
			;;
		"up")
			if [ ! -f $PROJECT_FILE ]; then
				di::log::warn "Run 'dine init' before upping the services"
			fi;
			for SERVICE in ${DINEIN_SERVICES[@]}; do
				PLUGIN_INIT="di::${SERVICE}::init"
				if type $PLUGIN_INIT &> /dev/null; then
					$PLUGIN_INIT
				fi
			done
			;;
		"down")
			di::not_implemented $CMD
			;;

		"start")
			di::start $2
			;;
		"stop")
			di::stop $2
			;;
		"list")
			di::log::header "Plugins:"
			for PLUGIN in ${PLUGINS[@]}; do
				di::log $PLUGIN

			done
			;;
		"ps")
			di::ps ${DINEIN_DOCKER_PREFIX}
			;;
		"config")
			di::config $SUB $ARGS
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
				di::unknown_command $CMD $SUB
			fi
			;;
	esac
}

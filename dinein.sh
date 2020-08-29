#!/usr/bin/env bash

set -euo pipefail

DINEIN_CONFIG_DIR=${DINEIN_CONFIG_DIR:-$HOME/.config/dinein}
DIVEIN_DOCKER_PREFIX=${DIVEIN_DOCKER_PREFIX:-dinein}

PLUGIN_DIR=./plugins
PLUGINS=()
SERVERS=()
SERVICES=()

if [[ "$TERM" != "dumb" ]] && [[ "$TERM" != "" ]]; then
    TBLD=$(tput bold)
    TUNL=$(tput smul)
    TGRN=$(tput setaf 2)
    TYLW=$(tput setaf 3)
    TRED=$(tput setaf 1)
    TBLU=$(tput setaf 4)
    TWHT=$(tput setaf 7)
    TOFF=$(tput sgr0)
    TDIM=$(tput dim)
    TBND=$TBLD
    TEPH=$TBND$TBLU
    TERR=$TBLD$TRED
    TWRN=$TBLD$TYLW
else
    TBLD=""
    TUNL=""
    TGRN=""
    TYLW=""
    TRED=""
    TBLU=""
    TWHT=""
    TOFF=""
    TDIM=""
    TBND=""
    TEPH=""
    TERR=""
fi

function dinein_config() {
	echo "Dive-in config directory:"
	echo "  $DINEIN_CONFIG_DIR ${TDIM}(\$DINEIN_CONFIG_DIR)$TOFF"
	echo "Docker prefix:"
	echo "  $DIVEIN_DOCKER_PREFIX ${TDIM}(\$DIVEIN_DOCKER_PREFIX)$TOFF"
	echo "Plugin directory:"
	echo "  $PLUGIN_DIR"
	echo "Plugins:"
	echo "  ${PLUGINS[@]}"
	echo "Servers:"
	echo "  ${SERVERS[@]}"
	echo "Services:"
	echo "  ${SERVICES[@]}"
}

function dinein_help_header() {
	if type figlet > /dev/null; then
		echo -n $TEPH
		figlet -tf slant "Dine-in ( )" | sed 's/^/   /'
		echo -n $TOFF
	fi
}

function dinein_help() {
	dinein_help_header 
	echo ""
	echo "  ${TUNL}USAGE$TOFF:"
	echo ""
	echo "  ${TBLD}init$TOFF"
	echo "    Creates required services based ${TBLD}.dinein$TOFF file. A template"
	echo "    file is created if your project doesn't contain one."
	echo ""
	echo "  ${TBLD}ps$TOFF"
	echo "    Show container status"
	echo ""
	echo "  ${TBLD}[service] add$TOFF ${TEPH}name=service version=latest${TOFF}"
	echo "    Add service to your. You can create more than one service of the same type"
	echo "    just give it a different name."
	echo ""
	echo "  ${TBLD}[service] start$TOFF ${TEPH}name=service${TOFF}"
	echo "    Start the named service."
	echo ""
	echo "  ${TBLD}[service] stop$TOFF ${TEPH}name=service${TOFF}"
	echo "    Stop the named service."
	echo ""
	echo "  ${TBLD}[service] rm$TOFF ${TEPH}name=service${TOFF}"
	echo "    Remove the named service."
	echo ""
	echo "  ${TUNL}PLUGIN COMMANDS$TOFF:"
	echo ""

	for PLUGIN in ${PLUGINS[@]}; do
		if type "dinein_plugin_${PLUGIN}_add_help" &> /dev/null; then
			"dinein_plugin_${PLUGIN}_add_help"
		fi
	done
}

function dinein_check_requirements() {
	FAIL=0
	if ! type jq > /dev/null; then
		echo ""
		FAIL=1
		dinein_log_warn "jq is not installed"
		dinein_log "${TGRN}$ ${TOFF}${TBLD}apt install jq${TOFF} or"
		dinein_log "${TGRN}$ ${TOFF}${TBLD}brew install jq${TOFF} to install."
	fi

	if ! type docker > /dev/null; then
		echo ""
		FAIL=1
		dinein_log_warn "docker is not installed"
		dinein_log "Visit ${TBLD}${TUNL}https://docs.docker.com/get-docker/${TOFF} to install."
	fi

	if [ $FAIL -eq 1 ]; then
		exit 1
	fi
}

function dinein_add_help() {
	echo "  $1 ${TEPH}$2${TOFF}"
	echo "    $3"
	echo ""
}

function dinein_ps() {
	docker ps -a -f name=$1
}

function dinein_container_exists() {
	CONTAINER_NAME=$1
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		dinein_log_error "Container with name $CONTAINER_NAME doesn't exist'"
		exit 1
	fi
}

function dinein_start() {
	CONTAINER_NAME=$1
	dinein_container_exists $CONTAINER_NAME
	docker container start $CONTAINER_NAME 1>/dev/null
}

function dinein_stop() {
	CONTAINER_NAME=$1
	dinein_container_exists $CONTAINER_NAME
	docker container stop $CONTAINER_NAME 1>/dev/null
}

function dinein_rm() {
	CONTAINER_NAME=$1
	dinein_container_exists $CONTAINER_NAME
	docker container stop $CONTAINER_NAME 1>/dev/null
	docker container rm $CONTAINER_NAME 1>/dev/null
}

function dinein_not_implemented() {
	dinein_log_warn "NOT IMPLEMENTED: $1"
}

function dinein_unknown_command() {
	dinein_log_error "UNKNOWN COMMAND: $@"
}

function dinein_local() {
	local PROJECT_FILE="$(pwd)/.dinein"
	if [ -f $PROJECT_FILE ]; then
		source $PROJECT_FILE
	fi
}

function dinein_log() {
	echo $1
}

function dinein_log_error() {
	COLOR=${2:-$TERR}
	echo
	echo "  ${COLOR}$1${TOFF}"
	echo
}

function dinein_log_warn() {
	COLOR=${2:-$TWRN}
	echo ${COLOR}$1${TOFF}
}

function dinein_log_header() {
	COLOR=${2:-$TBLD}
	echo ${COLOR}$1${TOFF}
}

function dinein_create_config_dir() {
	mkdir -p "$DINEIN_CONFIG_DIR/$1"
	echo "$DINEIN_CONFIG_DIR/$1"
}

function dinein_bootstrap() {
	dinein_check_requirements
	dinein_local
	local CMD=${1:-""}
	local SUB=${2:-""}
	local ARGS=${@:3}
	case "$CMD" in
		"init")
			dinein_help_header
			local PROJECT_FILE="$(pwd)/.dinein"
			if [ ! -f $PROJECT_FILE ]; then
				dinein_log_header "Creating .dinein project file. Edit it and run init again."
				dinein_log_header "You can see list of services by running 'dinein list'"
				dinein_log ""
				dinein_log "  .dinein"
				cat <<-TEMPLATE > ".dinein"
				DINEIN_PROJECT="project_code"
				DINEIN_SERVICES=(mysql redis)
TEMPLATE
			else
				for SERVICE in ${DINEIN_SERVICES[@]}; do
					PLUGIN_INIT="dinein_plugin_${SERVICE}_init"
					if type $PLUGIN_INIT &> /dev/null; then
						$PLUGIN_INIT
					fi
				done
			fi
			;;
		"ps")
			dinein_ps $DIVEIN_DOCKER_PREFIX
			;;
		"config")
			dinein_config $SUB $ARGS
			;;
		"help")
			dinein_help $CMD $SUB
			;;
		"")
			dinein_help $CMD $SUB
			;;
		*)
			FOUND=0
			for PLUGIN in ${PLUGINS[@]}; do
				if [[ "$PLUGIN" == "$CMD" ]]; then
					FOUND=1
					EXE="dinein_plugin_$PLUGIN"
					$EXE $SUB $ARGS
				fi
			done


			if [ $FOUND -eq 0 ]; then
				dinein_help $CMD $SUB
				dinein_unknown_command $CMD $SUB
			fi
			;;
	esac
}

for PLUGIN in $(ls $PLUGIN_DIR); do
  source "$PLUGIN_DIR/$PLUGIN"
  PLUGINS+=($PLUGIN_CMD)
  if [[ "$PLUGIN_SERVICE" == "true" ]]; then
	  SERVICES+=($PLUGIN_CMD)
  fi
  if [[ "$PLUGIN_SERVER" == "true" ]]; then
	  SERVERS+=($PLUGIN_CMD)
  fi
done

dinein_bootstrap $@

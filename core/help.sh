#!/usr/bin/env bash

function di::help() {
	di::help::header 
	echo "  A lightweight development tool similar to Tighten's Takeout."
	echo ""
	echo "  ${TUNL}USAGE$TOFF:"
	echo ""
	echo "  ${TBLD}init$TOFF"
	echo "    Creates a project file called .dinein in the current folder."
	echo ""
	echo "  ${TBLD}up$TOFF"
	echo "    Creates and starts your services and as well as inits each of the plugins."
	echo ""
	echo "  ${TBLD}down$TOFF"
	echo "    Stops the dine-in services."
	echo ""
	echo "  ${TBLD}ps$TOFF"
	echo "    Show container status."
	echo ""
	echo "  ${TBLD}list$TOFF"
	echo "    Lists available plugins."
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
		if type "di::${PLUGIN}::add_help" &> /dev/null; then
			"di::${PLUGIN}::add_help"
		fi
	done
}

function di::help::config() {
	di::log::header "Dive-in root:"
	echo "  $DINEIN_ROOT"
	di::log::header "Dive-in config directory:"
	echo "  $DINEIN_CONFIG_DIR ${TDIM}(\$DINEIN_CONFIG_DIR)$TOFF"
	di::log::header "Docker prefix:"
	echo "  $DINEIN_DOCKER_PREFIX ${TDIM}(\$DINEIN_DOCKER_PREFIX)$TOFF"
	di::log::header "Plugin directory:"
	echo "  $PLUGIN_DIR"
	di::log::header "Service plugins:"
	echo "  ${SERVICES[@]}"
	di::log::header "Host plugins:"
	echo "  ${HOSTS[@]}"
}

function di::help::add() {
	echo "  $1 ${TEPH}$2${TOFF}"
	echo "    $3"
	echo ""
}

function di::help::header() {
	MSG=${1:-"DINE-IN"}
	if type figlet 2>$1 > /dev/null; then
		echo -n $TEPH
		figlet -tf slant "$MSG" | sed 's/^/   /'
		echo $TOFF
	else
		echo
		echo "  $TEPH$TUNL$MSG$TOFF"
		echo
	fi
}

function di::help::unknown_command() {
	di::log::error "UNKNOWN COMMAND: $@"
}


#!/usr/bin/env bash

PLUGIN_NAME="Mailhog"
PLUGIN_CMD="mailhog"
PLUGIN_SERVICE=true
PLUGIN_BACKEND=false

function di::mailhog::add() {
	NAME=${1-mailhog}
	VERSON=${2:-latest}
	PORT=${3:-1025}
	UI_PORT=${4:-8025}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		di::log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:1025 \
			-p $UI_PORT:8025 \
			-d mailhog/mailhog:$VERSON
	else
		di::docker::start $CONTAINER_NAME
	fi
}

function di::mailhog::stop() {
	di::log::header "Stopping mailhog service"
	NAME=${1:-"mailhog"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
	di::log "Service stopped"
}

function di::mailhog::rm() {
	di::log::header "Removing mailhog service"
	NAME=${1:-"mailhog"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
	di::log "Service removed"
}

function di::mailhog::init() {
	di::mailhog::add
}

function di::mailhog::run() {
	case $1 in
		add|start)
			di::mailhog::add ${@:2}
			;;
		stop)
			di::help::not_implemented $1
			;;
		rm)
			di::mailhog::rm ${@:2}
			;;
		ps)
			di::docker::ps mailhog${2:@}
			;;
		*)
			di::unknown_command mailhog $1
			;;
	esac
}

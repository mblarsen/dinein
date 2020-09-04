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
		di::log::success "Created container"
	else
		di::docker::start $CONTAINER_NAME
	fi
	di::log::dim "HOST: 127.0.0.1:$PORT ($VERSON)"
	di::log::dim "UI: 127.0.0.1:$UI_PORT"
}

function di::mailhog::stop() {
	NAME=${1:-"mailhog"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
}

function di::mailhog::rm() {
	NAME=${1:-"mailhog"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
}

function di::mailhog::init() {
	di::log::header "Mailhog"
	di::mailhog::add
}

function di::mailhog::run() {
	di::log::header "Mailhog"
	case $1 in
		add|start)
			di::mailhog::add ${@:2}
			;;
		stop)
			di:mailhog::stop ${@:2}
			;;
		rm)
			di::mailhog::rm ${@:2}
			;;
		ps)
			di::docker::ps mailhog${2:@}
			;;
		*)
			di::help::unknown_command mailhog $1
			;;
	esac
}

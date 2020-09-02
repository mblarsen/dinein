#!/usr/bin/env bash

PLUGIN_NAME="Mailhog"
PLUGIN_CMD="mailhog"
PLUGIN_SERVICE=true
PLUGIN_HOST=false

function dinein_plugin_mailhog_add() {
	NAME=${1-mailhog}
	VERSON=${2:-latest}
	PORT=${3:-1025}
	UI_PORT=${4:-8025}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		dinein_log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:1025 \
			-p $UI_PORT:8025 \
			-d mailhog/mailhog:$VERSON
	else
		dinein_start $CONTAINER_NAME
	fi
}

function dinein_plugin_mailhog_stop() {
	dinein_log_header "Stopping mailhog service"
	NAME=${1:-"mailhog"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein_stop $CONTAINER_NAME
	dinein_log "Service stopped"
}

function dinein_plugin_mailhog_rm() {
	dinein_log_header "Removing mailhog service"
	NAME=${1:-"mailhog"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein_rm $CONTAINER_NAME
	dinein_log "Service removed"
}

function dinein_plugin_mailhog_init() {
	# TODO use data from .dinein
	dinein_plugin_mailhog_add
}

function dinein_plugin_mailhog() {
	case $1 in
		add|start)
			dinein_plugin_mailhog_add ${@:2}
			;;
		stop)
			dinein_not_implemented $1
			;;
		rm)
			dinein_plugin_mailhog_rm ${@:2}
			;;
		ps)
			dinein_ps mailhog${2:@}
			;;
		*)
			dinein_unknown_command mailhog $1
			;;
	esac
}

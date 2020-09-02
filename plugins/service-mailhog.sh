#!/usr/bin/env bash

PLUGIN_NAME="Mailhog"
PLUGIN_CMD="mailhog"
PLUGIN_SERVICE=true
PLUGIN_HOST=false

function dinein::plugin_mailhog_add() {
	NAME=${1-mailhog}
	VERSON=${2:-latest}
	PORT=${3:-1025}
	UI_PORT=${4:-8025}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		dinein::log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:1025 \
			-p $UI_PORT:8025 \
			-d mailhog/mailhog:$VERSON
	else
		dinein::start $CONTAINER_NAME
	fi
}

function dinein::plugin_mailhog_stop() {
	dinein::log_header "Stopping mailhog service"
	NAME=${1:-"mailhog"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein::stop $CONTAINER_NAME
	dinein::log "Service stopped"
}

function dinein::plugin_mailhog_rm() {
	dinein::log_header "Removing mailhog service"
	NAME=${1:-"mailhog"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein::rm $CONTAINER_NAME
	dinein::log "Service removed"
}

function dinein::plugin_mailhog_init() {
	# TODO use data from .dinein
	dinein::plugin_mailhog_add
}

function dinein::plugin_mailhog() {
	case $1 in
		add|start)
			dinein::plugin_mailhog_add ${@:2}
			;;
		stop)
			dinein::not_implemented $1
			;;
		rm)
			dinein::plugin_mailhog_rm ${@:2}
			;;
		ps)
			dinein::ps mailhog${2:@}
			;;
		*)
			dinein::unknown_command mailhog $1
			;;
	esac
}

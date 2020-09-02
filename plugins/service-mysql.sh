#!/usr/bin/env bash

PLUGIN_NAME="MySQL"
PLUGIN_CMD="mysql"
PLUGIN_SERVICE=true
PLUGIN_HOST=false

function dinein_plugin_mysql_add() {
	NAME=${1:-"mysql"}
	VERSON=${2:-latest}
	PORT=${3:-3306}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		dinein_log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:3306 \
			-e MYSQL_DATABASE=dinein \
			-e MYSQL_ROOT_PASSWORD=dinein \
			-e MYSQL_USER=dinein \
			-e MYSQL_PASSWORD=dinein \
			-d mysql:$VERSON
	else
		dinein_start $CONTAINER_NAME
	fi
}

function dinein_plugin_mysql_stop() {
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein_stop $CONTAINER_NAME
}

function dinein_plugin_mysql_rm() {
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein_rm $CONTAINER_NAME
}

function dinein_plugin_mysql_add_help() {
	dinein_add_help "mysql db" "name=mysql database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}."
}

function dinein_plugin_mysql_init() {
	# TODO use data from .dinein
	dinein_plugin_mysql_add
	if [ -z $DINEIN_PROJECT ]; then
		echo "Create database"
	fi
}

function dinein_plugin_mysql() {
	case $1 in
		add|start)
			dinein_plugin_mysql_add ${@:2}
			;;
		stop)
			dinein_plugin_mysql_stop ${@:2}
			;;
		rm)
			dinein_plugin_mysql_rm ${@:2}
			;;
		db)
			dinein_not_implemented $1
			;;
		*)
			dinein_unknown_command mysql $1
			;;
	esac
}

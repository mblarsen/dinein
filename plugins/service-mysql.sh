#!/usr/bin/env bash

PLUGIN_NAME="MySQL"
PLUGIN_CMD="mysql"
PLUGIN_SERVICE=true
PLUGIN_SERVER=false

function dinein_plugin_mysql_add() {
	dinein_util_log_header "Starting mysql service"
	NAME=${1:-"mysql"}
	VERSON=${2:-latest}
	PORT=${3:-3306}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		dinein_util_log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:3306 \
			-e MYSQL_DATABASE=dinein \
			-e MYSQL_ROOT_PASSWORD=dinein \
			-e MYSQL_USER=dinein \
			-e MYSQL_PASSWORD=dinein \
			-d mysql:$VERSON
	else
		dinein_util_log "Service existed: booting"
		dinein_util_start $CONTAINER_NAME
	fi
	dinein_util_log "Service is ready"
}

function dinein_plugin_mysql_stop() {
	dinein_util_log_header "Stopping mysql service"
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein_util_stop $CONTAINER_NAME
	dinein_util_log "Service stopped"
}

function dinein_plugin_mysql_rm() {
	dinein_util_log_header "Removing mysql service"
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein_util_stop $CONTAINER_NAME
	dinein_util_log "Service removed"
}

function dinein_plugin_mysql_init() {
	dinein_plugin_mysql_add
	if [ -z $DINEIN_PROJECT ]; then
		echo "Create database"
	fi
	# TODO create db/user if defined
}

function dinein_plugin_mysql_add_help() {
	dinein_util_add_help "mysql db" "name=mysql database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}."
}


function dinein_plugin_mysql() {
	case $1 in
		add|start)
			dinein_plugin_mysql_add ${@:2}
			;;
		stop)
			dinein_plugin_mysql_stop ${@:2}
			;;
		db)
			dinein_util_not_implemented $1
			;;
		rm)
			dinein_plugin_mysql_rm ${@:2}
			;;
		*)
			dinein_util_unknown_command mysql $1
			;;
	esac
}

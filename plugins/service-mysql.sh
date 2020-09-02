#!/usr/bin/env bash

PLUGIN_NAME="MySQL"
PLUGIN_CMD="mysql"
PLUGIN_SERVICE=true
PLUGIN_BACKEND=false

function di::mysql::add() {
	NAME=${1:-"mysql"}
	VERSON=${2:-latest}
	PORT=${3:-3306}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		di::log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:3306 \
			-e MYSQL_DATABASE=dinein \
			-e MYSQL_ROOT_PASSWORD=dinein \
			-e MYSQL_USER=dinein \
			-e MYSQL_PASSWORD=dinein \
			-d mysql:$VERSON
	else
		di::docker::start $CONTAINER_NAME
	fi
}

function di::mysql::stop() {
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
}

function di::mysql::rm() {
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
}

function di::mysql::add_help() {
	di::help::add "mysql db" "name=mysql database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}."
}

function di::mysql::init() {
	# TODO use data from .dinein
	di::mysql::add
	if [ -z $DINEIN_PROJECT ]; then
		echo "Create database"
	fi
}

function di::mysql::run() {
	case $1 in
		add|start)
			di::mysql::add ${@:2}
			;;
		stop)
			di::mysql::stop ${@:2}
			;;
		rm)
			di::mysql::rm ${@:2}
			;;
		db)
			di::not_implemented $1
			;;
		*)
			di::unknown_command mysql $1
			;;
	esac
}

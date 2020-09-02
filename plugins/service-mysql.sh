#!/usr/bin/env bash

PLUGIN_NAME="MySQL"
PLUGIN_CMD="mysql"
PLUGIN_SERVICE=true
PLUGIN_HOST=false

function dinein::mysql::add() {
	NAME=${1:-"mysql"}
	VERSON=${2:-latest}
	PORT=${3:-3306}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		dinein::log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:3306 \
			-e MYSQL_DATABASE=dinein \
			-e MYSQL_ROOT_PASSWORD=dinein \
			-e MYSQL_USER=dinein \
			-e MYSQL_PASSWORD=dinein \
			-d mysql:$VERSON
	else
		dinein::start $CONTAINER_NAME
	fi
}

function dinein::mysql::stop() {
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein::stop $CONTAINER_NAME
}

function dinein::mysql::rm() {
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein::rm $CONTAINER_NAME
}

function dinein::mysql::add_help() {
	dinein::add_help "mysql db" "name=mysql database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}."
}

function dinein::mysql::init() {
	# TODO use data from .dinein
	dinein::mysql::add
	if [ -z $DINEIN_PROJECT ]; then
		echo "Create database"
	fi
}

function dinein::mysql::run() {
	case $1 in
		add|start)
			dinein::mysql::add ${@:2}
			;;
		stop)
			dinein::mysql::stop ${@:2}
			;;
		rm)
			dinein::mysql::rm ${@:2}
			;;
		db)
			dinein::not_implemented $1
			;;
		*)
			dinein::unknown_command mysql $1
			;;
	esac
}

#!/usr/bin/env bash

PLUGIN_NAME="MongoDB"
PLUGIN_CMD="mongo"
PLUGIN_SERVICE=true
PLUGIN_BACKEND=false

function di::mongo::add() {
	NAME=${1:-"mongo"}
	VERSON=${2:-latest}
	PORT=${3:-27017}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		di::log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:27017 \
			-e MONGO_INITDB_ROOT_USERNAME=dinein \
			-e MONGO_INITDB_ROOT_PASSWORD=dinein \
			-d mongo:$VERSON
	else
		di::docker::start $CONTAINER_NAME
	fi
}

function di::mongo::stop() {
	NAME=${1:-"mongo"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
}

function di::mongo::rm() {
	NAME=${1:-"mongo"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
}

function di::mongo::add_help() {
	di::help::add "mongo db" "name=mongo database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}."
}

function di::mongo::init() {
	# TODO use data from .dinein
	di::mongo::add
	if [ -z $DINEIN_PROJECT ]; then
		echo "Create database"
	fi
}

function di::mongo::run() {
	case $1 in
		add|start)
			di::mongo::add ${@:2}
			;;
		stop)
			di::mongo::stop ${@:2}
			;;
		rm)
			di::mongo::rm ${@:2}
			;;
		db)
			di::help::not_implemented $1
			;;
		*)
			di::unknown_command mongo $1
			;;
	esac
}

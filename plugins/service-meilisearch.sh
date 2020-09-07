#!/usr/bin/env bash

PLUGIN_NAME="Meili Search"
PLUGIN_CMD="meilisearch"
PLUGIN_SERVICE=true
PLUGIN_BACKEND=false

function di::meilisearch::add() {
	NAME=${1-meilisearch}
	VERSON=${2:-latest}
	PORT=${3:-7700}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		di::log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:7700 \
			-d getmeili/meilisearch:$VERSON
		di::log::success "Created container"
	else
		di::docker::start $CONTAINER_NAME
	fi
	di::log::dim "HOST: 127.0.0.1:$PORT ($VERSON)"
}

function di::meilisearch::stop() {
	NAME=${1:-"meilisearch"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
}

function di::meilisearch::rm() {
	NAME=${1:-"meilisearch"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
}

function di::meilisearch::up() {
	di::log::header "meilisearch"
	di::meilisearch::add
}

function di::meilisearch::run() {
	di::log::header "meilisearch"
	case $1 in
		add|start)
			di::meilisearch::add ${@:2}
			;;
		stop)
			di:meilisearch::stop ${@:2}
			;;
		rm)
			di::meilisearch::rm ${@:2}
			;;
		ps)
			di::docker::ps meilisearch${2:@}
			;;
		*)
			di::help::unknown_command meilisearch $1
			;;
	esac
}

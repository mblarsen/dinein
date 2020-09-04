#!/usr/bin/env bash

PLUGIN_NAME="Redis"
PLUGIN_CMD="redis"
PLUGIN_SERVICE=true
PLUGIN_BACKEND=false

function di::redis::add() {
	NAME=${1-redis}
	VERSON=${2:-latest}
	PORT=${3:-6379}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	local REDIS_CONFIG="$(di::core::create_config_dir redis)/redis.conf"
	cat <<-TEMPLATE > "$REDIS_CONFIG"
port 6379
bind 0.0.0.0
requirepass dinein
TEMPLATE
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		di::log "Creating $CONTAINER_NAME"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:6379 \
			-v "$REDIS_CONFIG:/usr/local/etc/redis/redis.conf" \
			-d redis:$VERSON \
			redis-server /usr/local/etc/redis/redis.conf
	else
		di::docker::start $CONTAINER_NAME
	fi
}

function di::redis::stop() {
	di::log::header "Stopping redis service"
	NAME=${1:-"redis"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
	di::log "Service stopped"
}

function di::redis::rm() {
	di::log::header "Removing redis service"
	NAME=${1:-"redis"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
	di::log "Service removed"
}

function di::redis::add_help() {
	di::help::add "redis clear" "name=redis" "Clear the cache."
}

function di::redis::init() {
	# TODO use data from .dinein
	di::redis::add
}

function di::redis::run() {
	case $1 in
		add|start)
			di::redis::add ${@:2}
			;;
		stop)
			di::help::not_implemented $1
			;;
		rm)
			di::redis::rm ${@:2}
			;;
		clear)
			di::help::not_implemented $1
			;;

		*)
			di::help::unknown_command redis $1
			;;
	esac
}

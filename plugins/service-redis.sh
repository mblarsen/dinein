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
	local REDIS_DATA="$(di::core::create_config_dir redis/data)"
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
			-v "$REDIS_DATA:/usr/local/etc/redis/data/" \
			-d redis:$VERSON \
			redis-server /usr/local/etc/redis/redis.conf
		di::log::success "Created container"
	else
		di::docker::start $CONTAINER_NAME
	fi
	di::log::dim "Host: 127.0.0.1:$PORT ($VERSON)"
	di::log::dim "Password: dinein"
	di::log::dim "Shared config: $REDIS_CONFIG"
}

function di::redis::stop() {
	NAME=${1:-"redis"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
}

function di::redis::rm() {
	NAME=${1:-"redis"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
}

function di::redis::help::add() {
	di::help::add "redis clear" "name=redis" "Clear the cache."
}

function di::redis::up() {
	di::log::header "Redis"
	di::redis::add
}

function di::redis::run() {
	di::log::header "Redis"
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

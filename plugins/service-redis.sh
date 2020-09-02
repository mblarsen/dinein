#!/usr/bin/env bash

PLUGIN_NAME="Redis"
PLUGIN_CMD="redis"
PLUGIN_SERVICE=true
PLUGIN_HOST=false

function dinein::redis::add() {
	NAME=${1-redis}
	VERSON=${2:-latest}
	PORT=${3:-6379}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	local REDIS_CONFIG="$(dinein::create_config_dir redis)/redis.conf"
	cat <<-TEMPLATE > "$REDIS_CONFIG"
port 6379
bind 0.0.0.0
requirepass dinein
TEMPLATE
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		dinein::log "Creating $CONTAINER_NAME"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:6379 \
			-v "$REDIS_CONFIG:/usr/local/etc/redis/redis.conf" \
			-d redis:$VERSON \
			redis-server /usr/local/etc/redis/redis.conf
	else
		dinein::start $CONTAINER_NAME
	fi
}

function dinein::redis::stop() {
	dinein::log_header "Stopping redis service"
	NAME=${1:-"redis"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein::stop $CONTAINER_NAME
	dinein::log "Service stopped"
}

function dinein::redis::rm() {
	dinein::log_header "Removing redis service"
	NAME=${1:-"redis"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein::rm $CONTAINER_NAME
	dinein::log "Service removed"
}

function dinein::redis::add_help() {
	dinein::add_help "redis clear" "name=redis" "Clear the cache."
}

function dinein::redis::init() {
	# TODO use data from .dinein
	dinein::redis::add
}

function dinein::plugin_redis() {
	case $1 in
		add|start)
			dinein::redis::add ${@:2}
			;;
		stop)
			dinein::not_implemented $1
			;;
		rm)
			dinein::redis::rm ${@:2}
			;;
		clear)
			dinein::not_implemented $1
			;;

		*)
			dinein::unknown_command redis $1
			;;
	esac
}

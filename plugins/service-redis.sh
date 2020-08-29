#!/usr/bin/env bash

PLUGIN_NAME="Redis"
PLUGIN_CMD="redis"
PLUGIN_SERVICE=true
PLUGIN_SERVER=false

function dinein_plugin_redis_add() {
	dinein_util_log_header "Starting redis service"
	NAME=${1-redis}
	VERSON=${2:-latest}
	PORT=${3:-6379}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	local REDIS_CONFIG="$(dinein_util_create_config_dir redis)/redis.conf"
	cat <<-TEMPLATE > "$REDIS_CONFIG"
port 6379
bind 0.0.0.0
requirepass dinein
TEMPLATE
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		dinein_util_log "Crdineing $CONTAINER_NAME"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:6379 \
			-v "$REDIS_CONFIG:/usr/local/etc/redis/redis.conf" \
			-d redis:$VERSON \
			redis-server /usr/local/etc/redis/redis.conf
	else
		dinein_util_log "Service existed: booting"
		dinein_util_start $CONTAINER_NAME
	fi

	dinein_util_log "Service is ready"
}

function dinein_plugin_redis_stop() {
	dinein_util_log_header "Stopping redis service"
	NAME=${1:-"redis"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein_util_stop $CONTAINER_NAME
	dinein_util_log "Service stopped"
}

function dinein_plugin_redis_rm() {
	dinein_util_log_header "Removing redis service"
	NAME=${1:-"redis"}
	CONTAINER_NAME=${DIVEIN_DOCKER_PREFIX}_$NAME
	dinein_util_stop $CONTAINER_NAME
	dinein_util_log "Service removed"
}

function dinein_plugin_redis_add_help() {
	dinein_util_add_help "redis clear" "name=redis" "Clear the cache."
}

function dinein_plugin_redis() {
	case $1 in
		add|start)
			dinein_plugin_redis_add ${@:2}
			;;
		add|start)
			dinein_plugin_redis_add ${@:2}
			;;
		rm)
			dinein_util_not_implemented $1
			;;
		clear)
			dinein_util_not_implemented $1
			;;

		*)
			dinein_util_unknown_command redis $1
			;;
	esac
}

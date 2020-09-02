#!/usr/bin/env bash

function di::docker::ps() {
	docker ps \
		-a \
		--format "table {{.ID}}\t{{.Ports}}\t{{.Names}}" \
		-f name=$1 
}

function di::docker::exists() {
	CONTAINER_NAME=$1
	if [ "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		return 0
	fi
	di::log::error "Container '$CONTAINER_NAME' doesn't exist!"
	exit 1
}

function di::docker::running() {
	CONTAINER_NAME=$1
	CONTAINER_STATE=$(docker inspect $CONTAINER_NAME -f "{{.State.Running}}")
	if [ "$CONTAINER_STATE" == "true" ]; then
		return 0
	fi
	return 1
	 
}

function di::docker::start() {
	CONTAINER_NAME=$1

	set +e
	di::docker::exists $CONTAINER_NAME
	di::docker::running $CONTAINER_NAME
	local RUNNING=$?
	set -e

	di::log::header "$CONTAINER_NAME"

	if [ $RUNNING -eq 0 ]; then 
		di::log "Already running"
	else
		di::log "Starting"
		docker container start $CONTAINER_NAME 1>/dev/null
		di::log "Started"
	fi
}

function di::docker::stop() {
	CONTAINER_NAME=$1

	di::docker::exists $CONTAINER_NAME

	di::log::header "$CONTAINER_NAME"

	di::log "Stopping"
	docker container stop $CONTAINER_NAME 1>/dev/null
	di::log "Stopped"
}

function di::rm() {
	CONTAINER_NAME=$1

	di::docker::exists $CONTAINER_NAME

	docker container stop $CONTAINER_NAME 1>/dev/null
	docker container rm $CONTAINER_NAME 1>/dev/null
}

function di::not_implemented() {
	di::log::warn "NOT IMPLEMENTED: $1"
}


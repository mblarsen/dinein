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

	if [ $RUNNING -eq 0 ]; then 
		di::log::success "Already running"
	else
		di::log "Starting"
		docker container start $CONTAINER_NAME 1>/dev/null
		di::log::success "Started"
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

function di::docker::rm() {
	CONTAINER_NAME=$1

	di::docker::exists $CONTAINER_NAME

	docker container stop $CONTAINER_NAME 1>/dev/null
	di::log "Removing"
	docker container rm $CONTAINER_NAME 1>/dev/null
	di::log "Removed"
}

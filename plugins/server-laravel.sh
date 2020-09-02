#!/usr/bin/env bash

PLUGIN_NAME="Laravel artisan serve"
PLUGIN_CMD="laravel"
PLUGIN_SERVICE=false
PLUGIN_HOST=true

function dinein::laravel::link() {
	DINEIN_PROJECT=${1:-${DINEIN_PROJECT:-""}}

	if [[ "$DINEIN_PROJECT" == "" ]]; then
		dinein::log_error "Project name or DINEIN_PROJECT variable required"
	fi

	DINEIN_SITE=${2:-${DINEIN_SITE:-$DINEIN_PROJECT.test}}
	DINEIN_BACKEND=${3:-${DINEIN_BACKEND:-"127.0.0.1:8000"}}
	ROOT=${4:-"$(pwd)/public"}

	dinein::log_header "Linking site $DINEIN_PROJECT → $DINEIN_SITE [$DINEIN_BACKEND]"
	dinein::generate_site $DINEIN_PROJECT $DINEIN_SITE $ROOT $DINEIN_BACKEND
	dinein::log "Linked site"
}

function dinein::laravel::unlink() {
	DINEIN_PROJECT=${1:-${DINEIN_PROJECT:-""}}

	if [[ "$DINEIN_PROJECT" == "" ]]; then
		dinein::log_error "Project name or DINEIN_PROJECT variable required"
	fi

	dinein::log_header "Removing site $DINEIN_PROJECT"
	dinein::remove_site $DINEIN_PROJECT
	dinein::log "Removed site"
}

function dinein::laravel::add_help() {
	dinein::add_help "laravel link" "name [site] [backend] [root]" "Link a new website."
	dinein::add_help "laravel unlink" "name" "Remove a new website."
}

function dinein::laravel::run() {
	case $1 in
		link)
			dinein::laravel::link ${@:2}
			;;
		unlink)
			dinein::laravel::unlink ${@:2}
			;;
		*)
			dinein::unknown_command laravel $1
			;;
	esac
}

#!/usr/bin/env bash

PLUGIN_NAME="Laravel artisan serve"
PLUGIN_CMD="laravel"
PLUGIN_SERVICE=false
PLUGIN_HOST=true

function dinein_plugin_laravel_link() {
	DINEIN_PROJECT=${1:-${DINEIN_PROJECT:-""}}

	if [[ "$DINEIN_PROJECT" == "" ]]; then
		dinein_log_error "Project name or DINEIN_PROJECT variable required"
	fi

	DINEIN_SITE=${2:-${DINEIN_SITE:-$DINEIN_PROJECT.test}}
	DINEIN_BACKEND=${3:-${DINEIN_BACKEND:-"127.0.0.1:8000"}}
	ROOT=${4:-"$(pwd)/public"}

	dinein_log_header "Linking site $DINEIN_PROJECT → $DINEIN_SITE [$DINEIN_BACKEND]"
	dinein_generate_site $DINEIN_PROJECT $DINEIN_SITE $ROOT $DINEIN_BACKEND
	dinein_log "Linked site"
}

function dinein_plugin_laravel_unlink() {
	DINEIN_PROJECT=${1:-${DINEIN_PROJECT:-""}}

	if [[ "$DINEIN_PROJECT" == "" ]]; then
		dinein_log_error "Project name or DINEIN_PROJECT variable required"
	fi

	dinein_log_header "Removing site $DINEIN_PROJECT"
	dinein_remove_site $DINEIN_PROJECT 
	dinein_log "Removed site"
}

function dinein_plugin_laravel_add_help() {
	dinein_add_help "laravel link" "name [site] [backend] [root]" "Link a new website."
	dinein_add_help "laravel unlink" "name" "Remove a new website."
}

function dinein_plugin_laravel() {
	case $1 in
		link)
			dinein_plugin_laravel_link ${@:2}
			;;
		unlink)
			dinein_plugin_laravel_unlink ${@:2}
			;;
		*)
			dinein_unknown_command laravel $1
			;;
	esac
}

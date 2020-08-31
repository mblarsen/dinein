#!/usr/bin/env bash

PLUGIN_NAME="Laravel artisan serve"
PLUGIN_CMD="laravel"
PLUGIN_SERVICE=false
PLUGIN_HOST=true

function dinein_plugin_laravel_link() {
	NAME=${1:-$DINEIN_PROJECT}
	if [[ "$NAME" == "" ]]; then
		dinein_log_error "Name or DINEIN_PROJECT variable required"
	fi
	SITE=${2:-"${DINEIN_PROJECT}.net"}
	ROOT=${3:-"$(pwd)/public"}
	dinein_log_header "Linking site $NAME → $SITE"
	dinein_generate_site $NAME $SITE $ROOT 127.0.0.0:8000
	dinein_reload_server
}

function dinein_plugin_laravel_add_help() {
	dinein_add_help "laravel link" "name" "Link/park a new website."
	dinein_add_help "laravel unlink" "name" "Remove a new website."
}

function dinein_plugin_laravel() {
	case $1 in
		serve)
			dinein_not_implemented $1
			;;
		link)
			dinein_plugin_laravel_link ${@:2}
			;;
		unlink)
			dinein_not_implemented $1
			;;
		*)
			dinein_unknown_command laravel $1
			;;
	esac
}

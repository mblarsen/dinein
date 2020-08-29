#!/usr/bin/env bash

PLUGIN_NAME="Laravel artisan serve"
PLUGIN_CMD="laravel"
PLUGIN_SERVICE=false
PLUGIN_SERVER=true

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
			dinein_not_implemented $1
			;;
		unlink)
			dinein_not_implemented $1
			;;
		*)
			dinein_unknown_command laravel $1
			;;
	esac
}

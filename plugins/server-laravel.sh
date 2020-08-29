#!/usr/bin/env bash

PLUGIN_NAME="Laravel"
PLUGIN_CMD="laravel"
PLUGIN_SERVICE=false
PLUGIN_SERVER=true

function dinein_plugin_laravel_add_help() {
	echo -n ""
}

function dinein_plugin_mailhog() {
	case $1 in
		serve)
			dinein_not_implemented $1
			;;
		*)
			dinein_unknown_command laravel $1
			;;
	esac
}

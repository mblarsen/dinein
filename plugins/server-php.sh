#!/usr/bin/env bash

PLUGIN_NAME="Built-in PHP server"
PLUGIN_CMD="php"
PLUGIN_SERVICE=false
PLUGIN_SERVER=true

function dinein_plugin_php_add_help() {
	dinein_add_help "php link" "name" "Link a new website."
	dinein_add_help "php unlink" "name" "Remove a new website."
}

function dinein_plugin_php() {
	case $1 in
		link)
			dinein_not_implemented $1
			;;
		unlink)
			dinein_not_implemented $1
			;;
		*)
			dinein_unknown_command php $1
			;;
	esac
}

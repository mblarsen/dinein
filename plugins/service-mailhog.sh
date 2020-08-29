#!/usr/bin/env bash

PLUGIN_NAME="Mailhog"
PLUGIN_CMD="mailhog"
PLUGIN_SERVICE=true
PLUGIN_SERVER=false

function dinein_plugin_mailhog() {
	case $1 in
		add)
			dinein_util_not_implemented $1
			;;
		rm)
			dinein_util_not_implemented $1
			;;
		ps)
			dinein_util_ps mailhog${2:@}
			;;
		*)
			dinein_util_unknown_command mailhog $1
			;;
	esac
}

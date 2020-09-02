#!/usr/bin/env bash

# Generate a Caddyfile for the site being linked
function di::site::generate() {
	# E.g. 127.0.0.1:8000
	local FILE=$1
	local FILE_PATH="$(di::core::create_config_dir "caddy/sites")/$FILE"
	local SITE=$2
	local ROOT=$3
	local HOST=$4
	# TODO deal with root
	cat <<TEMPLATE > ${FILE_PATH}
https://$SITE {
    root * $ROOT 
    tls internal
    reverse_proxy $HOST {
        header_down Access-Control-Allow-Origin *
    }
}
TEMPLATE
	di::site::rebuild
}

# Removes a Caddyfile for a project
function di::site::remove() {
	local NAME=$1
	local FILE_PATH="$(di::core::create_config_dir "caddy/sites")/$NAME"
	[ -f $FILE_PATH ] && rm $FILE_PATH
	di::site::rebuild
}

function di::site::rebuild() {
	CADDY_FILE="$(di::core::create_config_dir caddy)/Caddyfile"
	CADDY_SITES=$(ls -d $(di::core::create_config_dir "caddy/sites")/*)
	cat $CADDY_SITES > $CADDY_FILE
}


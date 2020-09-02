#!/usr/bin/env bash


function di::site::caddy::running() {
	CADDY_STATUS=$(curl -o -I -L -s -w "%{http_code}" http://127.0.0.1:2019/config/)
	if [ "$CADDY_STATUS" == "200" ]; then
		return 0
	fi
	return 1
}

# Set up caddy
function di::site::caddy::start() {
	set +e
	di::site::caddy::running
	local RUNNING=$?
	set -e

	if [ $RUNNING -eq 0 ]; then
		di::log::warn "Caddy is already running"
		exit 0
	fi

	CADDY_FILE="$(di::core::create_config_dir caddy)/Caddyfile"
	CMD="sudo caddy start --config $CADDY_FILE --watch"
	di::log ""
	di::log::em "Dine-in is using Caddy to serve files and manage certificates."
	di::log ""
	di::log "To allow Caddy to bind to port :80 and :443 you'll need to run"
	di::log "Caddy as root. You only need to start the serve once. Caddy will"
	di::log "automatically look for changes to the config and reload as needed."
	di::log ""
	di::log    "This is the command that will run:"
	di::log ""
	di::log::warn "$CMD" $TGRN
	di::log ""
	di::log::em "You can abort the script and enter it yourself,"
	di::log::em "or enter your sudo password below (if needed)."
	di::log ""
	$CMD 1>/dev/null
}

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


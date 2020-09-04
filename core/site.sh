#!/usr/bin/env bash

function di::site::caddy::status() {
	echo $(curl -o -I -L -s -w "%{http_code}" http://127.0.0.1:2019/config/)
}

# Set up caddy
function di::site::caddy::start() {
	CADDY_STATUS=$(di::site::caddy::status)

	if [[ "$CADDY_STATUS" == "200" ]]; then
		di::log::warn "Caddy is already running"
		exit 0
	fi

	CADDY_FILE="$(di::core::create_config_dir caddy)/Caddyfile"
	CMD="sudo caddy start --config $CADDY_FILE --watch"

	if [ $(timeout 2 sudo id > /dev/null) ]; then
		di::log ""
		di::log::em "Dine-in is using Caddy to serve files and manage certificates."
		di::log ""
		di::log "To allow Caddy to bind to port :80 and :443 we need to run Caddy"
		di::log "with sudo rights the first time the server is started. Afterwards"
		di::log "Caddy willa utomatically look for changes to the config and reload"
		di::log "as needed."
		di::log ""
		di::log    "This is the command that will run:"
		di::log ""
		di::log::warn "$CMD" $TGRN
		di::log ""
		di::log::em "You can abort the script and enter it yourself,"
		di::log::em "or enter your sudo password below (if needed)."
		di::log ""
	fi
	$CMD > /dev/null 2>&1
	di::log ""
	di::log::success "Started Caddy"
}

function di::site::caddy::stop() {
	di::log::warn "Stopping Caddy"
	sudo caddy stop > /dev/null 2>&1
	di::log::success "Stopped"
}

# Generate a Caddyfile for the site being linked
function di::site::generate() {
	# E.g. 127.0.0.1:8000
	local FILE=$1
	local FILE_PATH="$(di::core::create_config_dir "caddy/sites")/$FILE"
	local SITE=$2
	local ROOT=$3
	local HOST=$4
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

# Rebuild joined Caddyfile
function di::site::rebuild() {
	CADDY_FILE="$(di::core::create_config_dir caddy)/Caddyfile"
	CADDY_SITES=$(ls -d $(di::core::create_config_dir "caddy/sites")/*)
	cat $CADDY_SITES > $CADDY_FILE
}


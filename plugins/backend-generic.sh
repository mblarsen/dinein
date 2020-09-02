#!/usr/bin/env bash

PLUGIN_NAME="Generic backend"
PLUGIN_CMD="php"
PLUGIN_SERVICE=false
PLUGIN_BACKEND=true

function di::php::link() {
	DINEIN_PROJECT=${1:-${DINEIN_PROJECT:-""}}

	if [[ "$DINEIN_PROJECT" == "" ]]; then
		di::log::error "Project name or DINEIN_PROJECT variable required"
	fi

	DINEIN_SITE=${2:-${DINEIN_SITE:-$DINEIN_PROJECT.test}}
	DINEIN_BACKEND=${3:-${DINEIN_BACKEND:-"127.0.0.1:8000"}}
	ROOT=${4:-"$(pwd)"}

	di::log::header "Linking site $DINEIN_PROJECT → $DINEIN_SITE [$DINEIN_BACKEND]"
	di::site::generate $DINEIN_PROJECT $DINEIN_SITE $ROOT $DINEIN_BACKEND
	di::log "Linked site"
}

function di::php::unlink() {
	DINEIN_PROJECT=${1:-${DINEIN_PROJECT:-""}}

	if [[ "$DINEIN_PROJECT" == "" ]]; then
		di::log::error "Project name or DINEIN_PROJECT variable required"
	fi

	di::log::header "Removing site $DINEIN_PROJECT"
	di::site::remove $DINEIN_PROJECT
	di::log "Removed site"
}

function di::php::add_help() {
	di::help::add "php link" "[name] [site] [backend] [root]" "Link a site. Uses .dinein for defaults."
	di::help::add "php unlink" "name" "Remove a new website. Uses .dinein for defaults."
}

function di::php::run() {
	case $1 in
		link)
			di::php::link ${@:2}
			;;
		unlink)
			di::php::unlink ${@:2}
			;;
		*)
			di::unknown_command php $1
			;;
	esac
}

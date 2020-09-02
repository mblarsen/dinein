#!/usr/bin/env bash

PLUGIN_NAME="Laravel artisan serve"
PLUGIN_CMD="laravel"
PLUGIN_SERVICE=false
PLUGIN_BACKEND=true

function di::laravel::link() {
	ROOT=${4:-"$(pwd)/public"}
	di::backend::link "" "" "" "$ROOT"
}

function di::laravel::unlink() {
	di::backend::unlink $@
}

function di::laravel::add_help() {
	di::help::add "laravel link" "[name] [site] [backend] [root]" "Link a site. Uses .dinein for defaults."
	di::help::add "laravel unlink" "name" "Remove a new website. Uses .dinein for defaults."
}

function di::laravel::run() {
	case $1 in
		link)
			di::laravel::link ${@:2}
			;;
		unlink)
			di::laravel::unlink ${@:2}
			;;
		*)
			di::unknown_command laravel $1
			;;
	esac
}

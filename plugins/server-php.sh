#!/usr/bin/env bash

PLUGIN_NAME="Built-in PHP server"
PLUGIN_CMD="php"
PLUGIN_SERVICE=false
PLUGIN_HOST=true

function dinein::php::add_help() {
	dinein::add_help "php link" "name" "Link a new website."
	dinein::add_help "php unlink" "name" "Remove a new website."
}

function dinein::php::run() {
	case $1 in
		link)
			dinein::not_implemented $1
			;;
		unlink)
			dinein::not_implemented $1
			;;
		*)
			dinein::unknown_command php $1
			;;
	esac
}

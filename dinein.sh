#!/usr/bin/env bash

set -euo pipefail

# Dine-in uses this folder to store plugin data
# e.g. the Caddyfile for the sites
DINEIN_CONFIG_DIR=${DINEIN_CONFIG_DIR:-$HOME/.config/dinein}

# Dine-in uses this as a prefix for all the containers that
# it starts. E.g. 'dinein' → 'dinein_redis'
DINEIN_DOCKER_PREFIX=${DINEIN_DOCKER_PREFIX:-dinein}

# Interally used to know where the code lives
DINEIN_ROOT=$(dirname "$(readlink -f "$0")")
# Interally used to know where the plugins lives
PLUGIN_DIR=$DINEIN_ROOT/plugins

# A list of all the plugins
PLUGINS=()
# A list of host-type plugins (eg. laravel, php)
HOSTS=()
# A list of service-type plugins (redis, mysql)
SERVICES=()

function di::core::boot() {
	for LIB in $(ls -d $DINEIN_ROOT/core/*); do
		source $LIB
	done
}

di::core::boot
di::core::run $@

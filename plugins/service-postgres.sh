#!/usr/bin/env bash

PLUGIN_NAME="PostgreSQL"
PLUGIN_CMD="psql"
PLUGIN_SERVICE=true
PLUGIN_BACKEND=false

function di::psql::add() {
	NAME=${1:-"psql"}
	VERSON=${2:-latest}
	PORT=${3:-5432}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		di::log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:5432 \
      -e POSTGRES_PASSWORD=dinein \
      -e POSTGRES_USER=dinein \
      -e POSTGRES_DB=dinein \
			-d postgres:$VERSON
		di::log::success "Created container"
	else
		di::docker::start $CONTAINER_NAME
	fi
	di::log::dim "HOST: 127.0.0.1:$PORT ($VERSON)"
	di::log::dim "USER: dinein"
	di::log::dim "DATABASE: dinein"
	di::log::dim "PASSWORD: dinein"
}

function di::psql::stop() {
	NAME=${1:-"psql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
}

function di::psql::rm() {
	NAME=${1:-"psql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
}

# TODO implement
function di::psql::db::create()
{
	NAME=${1:-"psql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	DB_NAME=${2:-$DINEIN_PROJECT}
	di::log::em "Creating database $DB_NAME on $CONTAINER_NAME"
	# docker exec -it $CONTAINER_NAME psql -uroot -pdinein -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
	# docker exec -it $CONTAINER_NAME psql -uroot -pdinein -e "CREATE USER IF NOT EXISTS '$DB_NAME'@'%' IDENTIFIED BY '$DB_NAME';"
	# docker exec -it $CONTAINER_NAME psql -uroot -pdinein -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_NAME'@'%';"
	di::log::success "Database created"
	di::log::dim "USER: $DB_NAME"
	di::log::dim "DATABASE: $DB_NAME"
	di::log::dim "PASSWORD: $DB_NAME"
}

# TODO implement
function di::psql::db::drop()
{
	NAME=${1:-"psql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	DB_NAME=${2:-$DINEIN_PROJECT}
	di::log::em "Removing database $DB_NAME on $CONTAINER_NAME"
	# docker exec -it $CONTAINER_NAME psql -uroot -pdinein -e "DROP DATABASE IF EXISTS $DB_NAME;"
	# docker exec -it $CONTAINER_NAME psql -uroot -pdinein -e "DROP USER IF EXISTS '$DB_NAME'@'%';"
	# docker exec -it $CONTAINER_NAME psql -uroot -pdinein -e "FLUSH PRIVILEGES;"
	di::log::success "Database dropped"
}

function di::psql::shell() {
	NAME=${1:-"psql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	docker exec -it $CONTAINER_NAME bash
}

# function di::psql::help::add() {
# 	di::help::add "psql db:create" "name=psql database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}. Creates a user by the same name."
# 	di::help::add "psql db:drop" "name=psql database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}."
# }

function di::psql::up() {
	di::log::header "PostgreSQL"
	di::psql::add
}

function di::psql::run() {
	di::log::header "PostgreSQL"
	case $1 in
		add|start)
			di::psql::add ${@:2}
			;;
		stop)
			di::psql::stop ${@:2}
			;;
		rm)
			di::psql::rm ${@:2}
			;;
		shell)
			di::psql::shell ${@:2}
			;;
		# db:create)
		# 	di::psql::db::create ${@:2}
		# 	;;
		# db:drop)
		# 	di::psql::db::drop ${@:2}
		# 	;;
		*)
			di::help::unknown_command psql $@
			;;
	esac
}

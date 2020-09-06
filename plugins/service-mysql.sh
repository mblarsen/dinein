#!/usr/bin/env bash

PLUGIN_NAME="MySQL"
PLUGIN_CMD="mysql"
PLUGIN_SERVICE=true
PLUGIN_BACKEND=false

function di::mysql::add() {
	NAME=${1:-"mysql"}
	VERSON=${2:-latest}
	PORT=${3:-3306}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	if [ ! "$(docker ps -a | grep $CONTAINER_NAME)" ]; then
		di::log "Creating container"
		docker run \
			--name $CONTAINER_NAME \
			-p $PORT:3306 \
			-e MYSQL_DATABASE=dinein \
			-e MYSQL_ROOT_PASSWORD=dinein \
			-e MYSQL_USER=dinein \
			-e MYSQL_PASSWORD=dinein \
			-d mysql:$VERSON
		di::log::success "Created container"
	else
		di::docker::start $CONTAINER_NAME
	fi
	di::log::dim "HOST: 127.0.0.1:$PORT ($VERSON)"
	di::log::dim "USER: dinein"
	di::log::dim "DATABASE: dinein"
	di::log::dim "PASSWORD: dinein"
	di::log::dim "ROOT_PASSWORD: dinein"
}

function di::mysql::stop() {
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::stop $CONTAINER_NAME
}

function di::mysql::rm() {
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	di::docker::rm $CONTAINER_NAME
}

function di::mysql::db::create()
{
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	DB_NAME=${2:-$DINEIN_PROJECT}
	di::log::em "Creating database $DB_NAME on $CONTAINER_NAME"
	docker exec -it $CONTAINER_NAME mysql -uroot -pdinein -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
	docker exec -it $CONTAINER_NAME mysql -uroot -pdinein -e "CREATE USER IF NOT EXISTS '$DB_NAME'@'localhost' IDENTIFIED BY 'dinein';"
	docker exec -it $CONTAINER_NAME mysql -uroot -pdinein -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_NAME'@'localhost';;"
	di::log::success "Database created"
}

function di::mysql::db::drop()
{
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	DB_NAME=${2:-$DINEIN_PROJECT}
	di::log::em "Removing database $DB_NAME on $CONTAINER_NAME"
	docker exec -it $CONTAINER_NAME mysql -uroot -pdinein -e "DROP DATABASE IF EXISTS $DB_NAME;"
	di::log::success "Database dropped"
}

function di::mysql::shell()
{
	NAME=${1:-"mysql"}
	CONTAINER_NAME=${DINEIN_DOCKER_PREFIX}_$NAME
	docker exec -it $CONTAINER_NAME bash
}

function di::mysql::help::add() {
	di::help::add "mysql db:create" "name=mysql database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}."
	di::help::add "mysql db:drop" "name=mysql database=\$DINEIN_PROJECT" "Create a db with name ${TBLU}database${TOFF} in the server ${TBLU}name${TOFF}."
}

function di::mysql::up() {
	di::log::header "MySQL"
	di::mysql::add
}

function di::mysql::run() {
	di::log::header "MySQL"
	case $1 in
		add|start)
			di::mysql::add ${@:2}
			;;
		stop)
			di::mysql::stop ${@:2}
			;;
		rm)
			di::mysql::rm ${@:2}
			;;
		shell)
			di::mysql::shell ${@:2}
			;;
		db:create)
			di::mysql::db::create ${@:2}
			;;
		db:drop)
			di::mysql::db::drop ${@:2}
			;;
		*)
			di::help::unknown_command mysql $@
			;;
	esac
}

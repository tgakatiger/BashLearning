#!/usr/bin/env bash

# Global variables
PGPASSWORD="G@zpr0mGaz"
PGUSER="postgres"
PGPORT=5432
PGHOST=""
DATABASES="Common Model Generated Log"
DUMPS="~/dumps/sapuib14"


# Aliases
alias l="ls -alh"
alias ll="ls -al"

# Functions
show_databases () {
    echo "show_databases"
    for i in $DATABASES
    do
	echo "$i"
    done
    unset i
}

backup () {
    if [ -z "$1" ]
    then
	for i in $DATABASES
	do
	    echo "psql -c \"some command on $i;\""
	done
    else
	if [ "$1" = "full" ]
	then
	    echo "pg_basebackup --pgdata=. --format=tar --gzipz --lable=\"full_backup\" --progress --verbose --no-password --username=$PGUSER --port=$PGPORT"
	fi
    fi    
    unset i
}

restore () {
    echo "Restore"
}

create () {
    for i in $DATABASES
    do
	echo "pqsl -U $PGUSER -c \"create database GRC.$i owner $PGUSER encoding 'utf8' template template1;\""
    done
    unset i
}

drop () {
    for i in $DATABASES
    do
	echo "psql -U $PGUSER -c \"revoke connect on database GRC.$i from public, $PGUSER;\""
	echo "psql -U $PGUSER -c \"select pg_terminate_backend(pid) from pg_stat_activity where pid <> pg_backend_pid() and datname = 'GRC.$i';\""
	echo "pqsl -U $PGUSER -c \"drop database if exists GRC.$i;\""
    done
    unset i
}


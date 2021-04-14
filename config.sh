#!/usr/bin/env bash


# Global variables
PGPASSWORD="G@zpr0mGaz"
PGUSER="postgres"
PGPORT=""
DATABASES="Common Model Generated Log"


# Aliases
alias l="ls -alh"
alias ll="ls -al"
alias p="psql -U $PGUSER"


# Functions
backup () {
	if [ -z "$1" ]
	then
		for i in $DATABASES
		do
			echo "pg_dump -U $PGUSER -Fc -d GRC.$i -f ./$i.dump -v"
			pg_dump -U $PGUSER -Fc -d GRC.$i -f ./$i.dump -v
		done
	elif [ "$1" = "full" ]
		then
			echo "pg_basebackup --pgdata=. --format=tar --gzip --lable=\"full_backup\" --progress --verbose --no-password --username=$PGUSER --port=$PGPORT"
			pg_basebackup --pgdata=. --format=tar --gzip --label=\"full_backup\" --progress --verbose --username=$PGUSER --port=$PGPORT
	elif [ "$1" = "all" ]
		then
			echo "pg_dumpall --clean -U $PGUSER -f ./dumpall.sql"
			pg_dumpall --clean -U $PGUSER -f ./dumpall.sql
	fi
	unset i
}

create () {
	for i in $DATABASES
	do
		echo "psql -U $PGUSER -c \"create database GRC.$i owner $PGUSER encoding 'utf8';\""
	done
	unset i
}

restore () {
	for i in $DATABASES
	do
		echo "pg_restore -U $PGUSER -d GRC.$i -v ./$i.dump"
		pg_restore -U $PGUSER -d GRC.$i -v ./$i.dump
	done
	unset i
}

drop () {
	for i in $DATABASES
	do
		echo "psql -U $PGUSER -c \"revoke connect on database GRC.$i from public, $PGUSER;\""
		echo "psql -U $PGUSER -c \"select pg_terminate_backend(pid) from pg_stat_activity where pid <> pg_backend_pid() and datname = 'GRC.$i';\""
		echo "psql -U $PGUSER -c \"drop databes if exists GRC.$i;\""
	done
	unset i
}

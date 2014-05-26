#!/bin/sh
################################################################################
# Install all modules
#
# Example: install.sh localhost ORA12C 1521 testuser passwort
################################################################################
DB_HOST_NAME=$1
DB_SERVICE_NAME=$2
DB_PORT=$3
USER_NAME=$4
USER_PASS=$5

for m in module_admin log_admin sql_admin object_admin partition_handler; do
	cd $m
	sqlplus ${USER_NAME}/${USER_PASS}@${DB_HOST_NAME}:${DB_PORT}/${DB_SERVICE_NAME} @install.sql
	cd ..
done
#!/bin/sh
################################################################################
# Install all modules
#
# Example: install.sh localhost ORA12C 1521 testuser passwort
################################################################################
set -x

usage() {
	echo -e "Execute: $0 <DB_HOST_NAME> <DB_SERVICE_NAME> <DB_PORT> <USER_NAME> <USER_PASS>\n"
	exit 1
}

[[ $# -ne 5 ]] && usage

DB_HOST_NAME=$1
DB_SERVICE_NAME=$2
DB_PORT=$3
USER_NAME=$4
USER_PASS=$5

DATA_TBS="USERS"
INDEX_TBS="USERS"
LOG_FILE="install.log"

sqlplus / as sysdba << EOSQL
	SET ECHO ON

	DROP USER ${USER_NAME} CASCADE;
	
	WHENEVER SQLERROR EXIT SQL.SQLCODE

	SPOOL ${LOG_FILE}

	CREATE USER ${USER_NAME} IDENTIFIED BY "${USER_PASS}"
		ACCOUNT UNLOCK
		DEFAULT TABLESPACE ${DATA_TBS};
	ALTER USER ${USER_NAME} QUOTA UNLIMITED ON ${DATA_TBS};
	ALTER USER ${USER_NAME} QUOTA UNLIMITED ON ${INDEX_TBS};
	GRANT CREATE SESSION TO ${USER_NAME};
	GRANT DEBUG CONNECT SESSION TO ${USER_NAME};
	GRANT CREATE TABLE TO ${USER_NAME};
	GRANT CREATE SEQUENCE TO ${USER_NAME};
	GRANT CREATE PROCEDURE TO ${USER_NAME};
	GRANT CREATE VIEW TO ${USER_NAME};
	GRANT CREATE TRIGGER TO ${USER_NAME};
	GRANT CREATE ANY CONTEXT TO ${USER_NAME};
	GRANT SELECT ANY DICTIONARY TO ${USER_NAME};
	GRANT ALTER ANY TABLE TO ${USER_NAME};
	GRANT ALTER ANY INDEX TO ${USER_NAME};

	CREATE OR REPLACE FUNCTION get_object_ddl(object_type_in IN VARCHAR2, name_in IN VARCHAR2, schema_in IN VARCHAR2) RETURN CLOB IS
	BEGIN
	  RETURN dbms_metadata.get_ddl(object_type => object_type_in, NAME => name_in, SCHEMA => schema_in);
	END get_object_ddl;
	/

	GRANT EXECUTE ON SYS.get_object_ddl TO ${USER_NAME};
	GRANT EXECUTE ON SYS.dbms_redefinition TO ${USER_NAME};

	@@module_admin/install.sql
	@@log_admin/install.sql
	@@sql_admin/install.sql
	@@object_admin/install.sql
	@@partition_handler/install.sql

	SPOOL OFF
EOSQL

exit $?

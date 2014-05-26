CREATE OR REPLACE PACKAGE sql_admin IS
  /****************************************************************************
  * SQL Admin
  *
  * Author:    Thomas Krahn
  * Date:      2013-09-30
  * Version:   0.3.4
  *
  * Requires:  log_admin    v1.2.3
  *            module_admin v0.7.0
  ****************************************************************************/
  gc_module_version CONSTANT module_admin.t_module_version := '0.3.4';
  gc_module_label   CONSTANT module_admin.t_module_label := $$PLSQL_UNIT || ' v' || gc_module_version;

  /******************************************************************************
  * Execute SQL statement.
  *
  * If wait_in equals 0 then error "Resource Busy" is raised, otherwise the SQL
  * will be executed until the resource is free again.
  ******************************************************************************/
  PROCEDURE execute_sql(sql_in IN CLOB, wait_in IN NUMBER DEFAULT 1);

  /******************************************************************************
  * Return 1 if current database version is Enterprise Edition
  ******************************************************************************/
  FUNCTION is_enterprise_edition RETURN NUMBER;

  /******************************************************************************
  * Return the name of the current database. Useful function because not all users
  * have access to V$DATABASE.
  ******************************************************************************/
  FUNCTION get_database_name RETURN v$database.name%TYPE;

  /******************************************************************************
  * Create an index.
  *
  * This function is determining if the current database edition is an Enterprise
  * Edition or not. If yes, the index will be created ONLINE and can be local
  * partitioned. If not, the index will be created without keyword ONLINE and
  * with no partitionins.
  ******************************************************************************/
  PROCEDURE create_index(index_owner_in     IN dba_indexes.owner%TYPE,
                         index_name_in      IN dba_indexes.index_name%TYPE,
                         table_owner_in     IN dba_indexes.table_owner%TYPE,
                         table_name_in      IN dba_indexes.table_name%TYPE,
                         columns_in         IN VARCHAR2,
                         tablespace_name_in IN dba_indexes.tablespace_name%TYPE,
                         unique_in          IN dba_indexes.uniqueness%TYPE DEFAULT NULL,
                         partitioned_in     IN dba_indexes.partitioned%TYPE DEFAULT 'NO');
END sql_admin;
/
CREATE OR REPLACE PACKAGE BODY sql_admin IS

  /******************************************************************************
  * Exceptions
  ******************************************************************************/
  e_resource_busy EXCEPTION; -- ORA-00054 Resource Busy
  PRAGMA EXCEPTION_INIT(e_resource_busy, -00054);

  /******************************************************************************
  * Execute SQL statement.
  *
  * If wait_in equals 0 and error "Resource Busy" is raised, the SQL will
  * be executed until it could successful be executed.
  ******************************************************************************/
  PROCEDURE execute_sql(sql_in IN CLOB, wait_in IN NUMBER DEFAULT 1) IS
    v_module_action log_admin.t_module_action := 'execute_sql';
    b_done          BOOLEAN := FALSE;
  BEGIN
    log_admin.debug(sql_in, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
  
    WHILE wait_in = 1 AND NOT b_done LOOP
      BEGIN
        EXECUTE IMMEDIATE (sql_in);
      
        b_done := TRUE;
      EXCEPTION
        WHEN e_resource_busy THEN
          NULL;
        WHEN OTHERS THEN
          RAISE;
      END;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      log_admin.error(sql_in, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action, sql_code_in => SQLCODE, sql_errm_in => SQLERRM);
      RAISE;
  END execute_sql;

  /******************************************************************************
  * Return 1 if current database version is Enterprise Edition
  ******************************************************************************/
  FUNCTION is_enterprise_edition RETURN NUMBER AS
    n_result NUMBER;
  BEGIN
    SELECT COUNT(1) INTO n_result FROM v$version WHERE instr(banner, 'Enterprise') != 0;
    RETURN n_result;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END is_enterprise_edition;

  /******************************************************************************
  * Return the name of the current database. Useful function because not all users
  * have access to V$DATABASE.
  ******************************************************************************/
  FUNCTION get_database_name RETURN v$database.name%TYPE IS
    v_result v$database.name%TYPE;
  BEGIN
    SELECT NAME INTO v_result FROM v$database;
    RETURN v_result;
  END get_database_name;

  /******************************************************************************
  * Create an index.
  *
  * This function is determining if the current database edition is an Enterprise
  * Edition or not. If yes, the index will be created ONLINE and can be local
  * partitioned. If not, the index will be created without keyword ONLINE and
  * with no partitions.
  ******************************************************************************/
  PROCEDURE create_index(index_owner_in     IN dba_indexes.owner%TYPE,
                         index_name_in      IN dba_indexes.index_name%TYPE,
                         table_owner_in     IN dba_indexes.table_owner%TYPE,
                         table_name_in      IN dba_indexes.table_name%TYPE,
                         columns_in         IN VARCHAR2,
                         tablespace_name_in IN dba_indexes.tablespace_name%TYPE,
                         unique_in          IN dba_indexes.uniqueness%TYPE DEFAULT NULL,
                         partitioned_in     IN dba_indexes.partitioned%TYPE DEFAULT 'NO') IS
    v_module_action log_admin.t_module_action := 'create_index';
    v_sql           VARCHAR2(4000 CHAR);
  BEGIN
    -- SR 3-7865713981 : CREATE INDEX ONLINE failed with ORA-01450 whereas it runs successful without ONLINE keyword
    -- Due to MOS doc 1368531.1 the DEFFERED_SEGMENT_CREATION will be disabled first.
    execute_sql('ALTER SESSION SET DEFERRED_SEGMENT_CREATION = FALSE');
    -- Create SQL for index creation
    v_sql := 'CREATE ' || unique_in || ' INDEX "' || index_owner_in || '"."' || index_name_in || '" ON "' || table_owner_in || '"."' || table_name_in || '" (' ||
             columns_in || ') TABLESPACE ' || tablespace_name_in;
    IF is_enterprise_edition = 1 THEN
      -- Add ONLINE keyword
      v_sql := v_sql || ' ONLINE';
      -- If partitioned_in = 'YES' add LOCAL keyword
      IF partitioned_in = 'YES' THEN
        v_sql := v_sql || ' LOCAL';
      END IF;
    END IF;
    execute_sql(sql_in => v_sql);
  EXCEPTION
    WHEN OTHERS THEN
      log_admin.error('Error while creating index "' || index_owner_in || '"."' || index_name_in || '": ' || dbms_utility.format_error_backtrace,
                      module_name_in => $$PLSQL_UNIT,
                      module_action_in => v_module_action,
                      sql_errm_in => SQLERRM,
                      sql_code_in => SQLCODE);
      RAISE;
  END create_index;

  /*******************************************************************************
  * Initialize
  *******************************************************************************/
  PROCEDURE initialize IS
    v_module_action log_admin.t_module_action := 'initialize';
  BEGIN
    module_admin.load_and_set_config(module_name_in => $$PLSQL_UNIT);
    log_admin.info(message_in => 'Initialized ' || gc_module_label, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
  END initialize;

BEGIN
  initialize;
END sql_admin;
/

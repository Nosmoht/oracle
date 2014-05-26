CREATE OR REPLACE PACKAGE log_admin IS
  /*****************************************************************************
  * Log Admin
  *
  * Author:        Thomas Krahn
  * Date:          2014-05-26
  * Version:       1.2.5
  *
  * Requires:      module_admin v0.7.0
  *****************************************************************************/
  gc_module_version CONSTANT module_admin.t_module_version := '1.2.5';
  gc_module_label   CONSTANT module_admin.t_module_label := $$PLSQL_UNIT || ' v' || gc_module_version;

  /*******************************************************************************
  * Types
  *******************************************************************************/
  SUBTYPE maxvarchardb IS VARCHAR2(4000 CHAR);
  SUBTYPE maxvarchar IS VARCHAR2(32767 CHAR);
  SUBTYPE t_log_severity_id IS log$severity.id%TYPE;
  SUBTYPE t_log_severity_name IS log$severity.name%TYPE;
  SUBTYPE t_insert_ts IS log$entry.insert_ts%TYPE;
  SUBTYPE t_module_name IS log$entry.module_name%TYPE;
  SUBTYPE t_module_action IS log$entry.module_action%TYPE;
  SUBTYPE t_message_text IS log$entry.message%TYPE;
  SUBTYPE t_message_lob IS log$entry.message_lob%TYPE;
  SUBTYPE t_sql_errm IS log$entry.sql_errm%TYPE;
  SUBTYPE t_sql_code IS log$entry.sql_code%TYPE;
  SUBTYPE t_username IS log$entry.username%TYPE;

  /*******************************************************************************
  * Constants
  *******************************************************************************/
  gc_maxvarchardb           CONSTANT PLS_INTEGER := 4000;
  gc_maxvarchar             CONSTANT PLS_INTEGER := 32767;
  gc_log_severity_attribute CONSTANT VARCHAR2(30 CHAR) := 'LOG_SEVERITY_ID';
  gc_emergency_id           CONSTANT t_log_severity_id := 1;
  gc_alert_id               CONSTANT t_log_severity_id := 2;
  gc_critical_id            CONSTANT t_log_severity_id := 3;
  gc_error_id               CONSTANT t_log_severity_id := 4;
  gc_warning_id             CONSTANT t_log_severity_id := 5;
  gc_notice_id              CONSTANT t_log_severity_id := 6;
  gc_informational_id       CONSTANT t_log_severity_id := 7;
  gc_debug_id               CONSTANT t_log_severity_id := 8;

  /******************************************************************************
  * Write a message of type EMERGENCY to the log table
  ******************************************************************************/
  PROCEDURE emergency(message_in       IN t_message_lob,
                      module_name_in   IN t_module_name DEFAULT NULL,
                      module_action_in IN t_module_action DEFAULT NULL,
                      username_in      IN t_username DEFAULT USER,
                      sql_errm_in      IN t_sql_errm DEFAULT NULL,
                      sql_code_in      IN t_sql_code DEFAULT NULL,
                      insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                      autonom_in       IN PLS_INTEGER DEFAULT 1);

  /******************************************************************************
  * Write a message of type ALERT to the log table
  ******************************************************************************/
  PROCEDURE alert(message_in       IN t_message_lob,
                  module_name_in   IN t_module_name DEFAULT NULL,
                  module_action_in IN t_module_action DEFAULT NULL,
                  username_in      IN t_username DEFAULT USER,
                  sql_errm_in      IN t_sql_errm DEFAULT NULL,
                  sql_code_in      IN t_sql_code DEFAULT NULL,
                  insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                  autonom_in       IN PLS_INTEGER DEFAULT 1);

  /******************************************************************************
  * Write a message of type CRITICAL to the log table
  ******************************************************************************/
  PROCEDURE critical(message_in       IN t_message_lob,
                     module_name_in   IN t_module_name DEFAULT NULL,
                     module_action_in IN t_module_action DEFAULT NULL,
                     username_in      IN t_username DEFAULT USER,
                     sql_errm_in      IN t_sql_errm DEFAULT NULL,
                     sql_code_in      IN t_sql_code DEFAULT NULL,
                     insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                     autonom_in       IN PLS_INTEGER DEFAULT 1);

  /******************************************************************************
  * Write a message of type ERROR to the log table
  ******************************************************************************/
  PROCEDURE error(message_in       IN t_message_lob,
                  module_name_in   IN t_module_name DEFAULT NULL,
                  module_action_in IN t_module_action DEFAULT NULL,
                  username_in      IN t_username DEFAULT USER,
                  sql_errm_in      IN t_sql_errm DEFAULT NULL,
                  sql_code_in      IN t_sql_code DEFAULT NULL,
                  insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                  autonom_in       IN PLS_INTEGER DEFAULT 1);

  /******************************************************************************
  * Write a message of type WARNING to the log table
  ******************************************************************************/
  PROCEDURE warning(message_in       IN t_message_lob,
                    module_name_in   IN t_module_name DEFAULT NULL,
                    module_action_in IN t_module_action DEFAULT NULL,
                    username_in      IN t_username DEFAULT USER,
                    sql_errm_in      IN t_sql_errm DEFAULT NULL,
                    sql_code_in      IN t_sql_code DEFAULT NULL,
                    insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                    autonom_in       IN PLS_INTEGER DEFAULT 1);

  /******************************************************************************
  * Write a message of type NOTICE to the log table
  ******************************************************************************/
  PROCEDURE notice(message_in       IN t_message_lob,
                   module_name_in   IN t_module_name DEFAULT NULL,
                   module_action_in IN t_module_action DEFAULT NULL,
                   username_in      IN t_username DEFAULT USER,
                   sql_errm_in      IN t_sql_errm DEFAULT NULL,
                   sql_code_in      IN t_sql_code DEFAULT NULL,
                   insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                   autonom_in       IN PLS_INTEGER DEFAULT 1);

  /******************************************************************************
  * Write a message of type INFO to the log table
  ******************************************************************************/
  PROCEDURE info(message_in       IN t_message_lob,
                 module_name_in   IN t_module_name DEFAULT NULL,
                 module_action_in IN t_module_action DEFAULT NULL,
                 username_in      IN t_username DEFAULT USER,
                 sql_errm_in      IN t_sql_errm DEFAULT NULL,
                 sql_code_in      IN t_sql_code DEFAULT NULL,
                 insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                 autonom_in       IN PLS_INTEGER DEFAULT 1);

  /******************************************************************************
  * Write a message of type DEBUG to the log table
  ******************************************************************************/
  PROCEDURE debug(message_in       IN t_message_lob,
                  module_name_in   IN t_module_name DEFAULT NULL,
                  module_action_in IN t_module_action DEFAULT NULL,
                  username_in      IN t_username DEFAULT USER,
                  sql_errm_in      IN t_sql_errm DEFAULT NULL,
                  sql_code_in      IN t_sql_code DEFAULT NULL,
                  insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                  autonom_in       IN PLS_INTEGER DEFAULT 1);

  /******************************************************************************
  * Truncate the table log$entry
  ******************************************************************************/
  PROCEDURE truncate_log_entry;
END log_admin;
/
CREATE OR REPLACE PACKAGE BODY log_admin IS
  /******************************************************************************
  * Insert a row into table log$entry
  ******************************************************************************/
  PROCEDURE do_write(insert_ts_in       IN t_insert_ts,
                     log_severity_id_in IN t_log_severity_id,
                     message_in         IN t_message_text,
                     message_lob_in     IN t_message_lob DEFAULT NULL,
                     username_in        IN t_username DEFAULT USER,
                     module_name_in     IN t_module_name DEFAULT NULL,
                     module_action_in   IN t_module_action DEFAULT NULL,
                     sql_errm_in        IN t_sql_errm,
                     sql_code_in        IN t_sql_code) AS
  BEGIN
    INSERT INTO log$entry
      (id, log_severity_id, insert_ts, username, message, module_name, module_action, sql_errm, sql_code, message_lob)
    VALUES
      (log$entry_id_seq.nextval,
       log_severity_id_in,
       insert_ts_in,
       username_in,
       message_in,
       module_name_in,
       module_action_in,
       sql_errm_in,
       sql_code_in,
       message_lob_in);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END do_write;

  /******************************************************************************
  * Write a message as autonomous transaction
  ******************************************************************************/
  PROCEDURE write_autonom(insert_ts_in       IN t_insert_ts,
                          log_severity_id_in IN t_log_severity_id,
                          message_in         IN t_message_text,
                          module_name_in     IN t_module_name DEFAULT NULL,
                          module_action_in   IN t_module_action DEFAULT NULL,
                          username_in        IN t_username DEFAULT USER,
                          sql_errm_in        IN t_sql_errm DEFAULT NULL,
                          sql_code_in        IN t_sql_code DEFAULT NULL,
                          message_lob_in     IN t_message_lob) AS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    do_write(insert_ts_in       => insert_ts_in,
             log_severity_id_in => log_severity_id_in,
             message_in         => message_in,
             username_in        => username_in,
             module_name_in     => module_name_in,
             module_action_in   => module_action_in,
             sql_errm_in        => sql_errm_in,
             sql_code_in        => sql_code_in,
             message_lob_in     => message_lob_in);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END write_autonom;

  /******************************************************************************
  * Write a log message. This procedure is the one used by all type specific
  * procedures.
  ******************************************************************************/
  PROCEDURE write_log(insert_ts_in       IN t_insert_ts,
                      log_severity_id_in IN t_log_severity_id,
                      message_in         IN t_message_lob,
                      module_name_in     IN t_module_name DEFAULT NULL,
                      module_action_in   IN t_module_action DEFAULT NULL,
                      username_in        IN t_username DEFAULT USER,
                      sql_errm_in        IN t_sql_errm DEFAULT NULL,
                      sql_code_in        IN t_sql_code DEFAULT NULL,
                      autonom_in         IN PLS_INTEGER) AS
    v_message     t_message_text;
    v_message_lob t_message_lob := NULL;
  BEGIN
    IF dbms_lob.getlength(message_in) > gc_maxvarchardb THEN
      v_message_lob := message_in;
      v_message     := substr(message_in, 1, gc_maxvarchardb);
    ELSE
      v_message := message_in;
    END IF;
    IF log_severity_id_in <= nvl(module_admin.get_module_value(module_name_in => module_name_in, parameter_in => gc_log_severity_attribute), gc_debug_id) THEN
      IF autonom_in = 1 THEN
        write_autonom(insert_ts_in       => insert_ts_in,
                      log_severity_id_in => log_severity_id_in,
                      message_in         => v_message,
                      message_lob_in     => v_message_lob,
                      username_in        => username_in,
                      module_name_in     => module_name_in,
                      module_action_in   => module_action_in,
                      sql_errm_in        => sql_errm_in,
                      sql_code_in        => sql_code_in);
      ELSE
        do_write(insert_ts_in       => insert_ts_in,
                 log_severity_id_in => log_severity_id_in,
                 message_in         => v_message,
                 message_lob_in     => v_message_lob,
                 username_in        => username_in,
                 module_name_in     => module_name_in,
                 module_action_in   => module_action_in,
                 sql_errm_in        => sql_errm_in,
                 sql_code_in        => sql_code_in);
      END IF;
    END IF;
  END write_log;

  /******************************************************************************
  * Write a message of type EMERGENCY to the log table
  ******************************************************************************/
  PROCEDURE emergency(message_in       IN t_message_lob,
                      module_name_in   IN t_module_name DEFAULT NULL,
                      module_action_in IN t_module_action DEFAULT NULL,
                      username_in      IN t_username DEFAULT USER,
                      sql_errm_in      IN t_sql_errm DEFAULT NULL,
                      sql_code_in      IN t_sql_code DEFAULT NULL,
                      insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                      autonom_in       IN PLS_INTEGER DEFAULT 1) AS
  BEGIN
    write_log(insert_ts_in       => insert_ts_in,
              log_severity_id_in => gc_emergency_id,
              message_in         => message_in,
              username_in        => username_in,
              module_name_in     => module_name_in,
              module_action_in   => module_action_in,
              sql_errm_in        => sql_errm_in,
              sql_code_in        => sql_code_in,
              autonom_in         => autonom_in);
  END emergency;

  /******************************************************************************
  * Write a message of type ALERT to the log table
  ******************************************************************************/
  PROCEDURE alert(message_in       IN t_message_lob,
                  module_name_in   IN t_module_name DEFAULT NULL,
                  module_action_in IN t_module_action DEFAULT NULL,
                  username_in      IN t_username DEFAULT USER,
                  sql_errm_in      IN t_sql_errm DEFAULT NULL,
                  sql_code_in      IN t_sql_code DEFAULT NULL,
                  insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                  autonom_in       IN PLS_INTEGER DEFAULT 1) AS
  BEGIN
    write_log(insert_ts_in       => insert_ts_in,
              log_severity_id_in => gc_alert_id,
              message_in         => message_in,
              username_in        => username_in,
              module_name_in     => module_name_in,
              module_action_in   => module_action_in,
              sql_errm_in        => sql_errm_in,
              sql_code_in        => sql_code_in,
              autonom_in         => autonom_in);
  END alert;

  /******************************************************************************
  * Write a message of type CRITICAL to the log table
  ******************************************************************************/
  PROCEDURE critical(message_in       IN t_message_lob,
                     module_name_in   IN t_module_name DEFAULT NULL,
                     module_action_in IN t_module_action DEFAULT NULL,
                     username_in      IN t_username DEFAULT USER,
                     sql_errm_in      IN t_sql_errm DEFAULT NULL,
                     sql_code_in      IN t_sql_code DEFAULT NULL,
                     insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                     autonom_in       IN PLS_INTEGER DEFAULT 1) AS
  BEGIN
    write_log(insert_ts_in       => insert_ts_in,
              log_severity_id_in => gc_critical_id,
              message_in         => message_in,
              username_in        => username_in,
              module_name_in     => module_name_in,
              module_action_in   => module_action_in,
              sql_errm_in        => sql_errm_in,
              sql_code_in        => sql_code_in,
              autonom_in         => autonom_in);
  END critical;

  /******************************************************************************
  * Write a message of type ERROR to the log table
  ******************************************************************************/
  PROCEDURE error(message_in       IN t_message_lob,
                  module_name_in   IN t_module_name DEFAULT NULL,
                  module_action_in IN t_module_action DEFAULT NULL,
                  username_in      IN t_username DEFAULT USER,
                  sql_errm_in      IN t_sql_errm DEFAULT NULL,
                  sql_code_in      IN t_sql_code DEFAULT NULL,
                  insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                  autonom_in       IN PLS_INTEGER DEFAULT 1) AS
  BEGIN
    write_log(insert_ts_in       => insert_ts_in,
              log_severity_id_in => gc_error_id,
              message_in         => message_in,
              username_in        => username_in,
              module_name_in     => module_name_in,
              module_action_in   => module_action_in,
              sql_errm_in        => sql_errm_in,
              sql_code_in        => sql_code_in,
              autonom_in         => autonom_in);
  END error;

  /******************************************************************************
  * Write a message of type WARNING to the log table
  ******************************************************************************/
  PROCEDURE warning(message_in       IN t_message_lob,
                    module_name_in   IN t_module_name DEFAULT NULL,
                    module_action_in IN t_module_action DEFAULT NULL,
                    username_in      IN t_username DEFAULT USER,
                    sql_errm_in      IN t_sql_errm DEFAULT NULL,
                    sql_code_in      IN t_sql_code DEFAULT NULL,
                    insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                    autonom_in       IN PLS_INTEGER DEFAULT 1) AS
  BEGIN
    write_log(insert_ts_in       => insert_ts_in,
              log_severity_id_in => gc_warning_id,
              message_in         => message_in,
              username_in        => username_in,
              module_name_in     => module_name_in,
              module_action_in   => module_action_in,
              sql_errm_in        => sql_errm_in,
              sql_code_in        => sql_code_in,
              autonom_in         => autonom_in);
  END warning;

  /******************************************************************************
  * Write a message of type NOTICE to the log table
  ******************************************************************************/
  PROCEDURE notice(message_in       IN t_message_lob,
                   module_name_in   IN t_module_name DEFAULT NULL,
                   module_action_in IN t_module_action DEFAULT NULL,
                   username_in      IN t_username DEFAULT USER,
                   sql_errm_in      IN t_sql_errm DEFAULT NULL,
                   sql_code_in      IN t_sql_code DEFAULT NULL,
                   insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                   autonom_in       IN PLS_INTEGER DEFAULT 1) AS
  BEGIN
    write_log(insert_ts_in       => insert_ts_in,
              log_severity_id_in => gc_notice_id,
              message_in         => message_in,
              username_in        => username_in,
              module_name_in     => module_name_in,
              module_action_in   => module_action_in,
              sql_errm_in        => sql_errm_in,
              sql_code_in        => sql_code_in,
              autonom_in         => autonom_in);
  END notice;

  /******************************************************************************
  * Write a message of type INFO to the log table
  ******************************************************************************/
  PROCEDURE info(message_in       IN t_message_lob,
                 module_name_in   IN t_module_name DEFAULT NULL,
                 module_action_in IN t_module_action DEFAULT NULL,
                 username_in      IN t_username DEFAULT USER,
                 sql_errm_in      IN t_sql_errm DEFAULT NULL,
                 sql_code_in      IN t_sql_code DEFAULT NULL,
                 insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                 autonom_in       IN PLS_INTEGER DEFAULT 1) AS
  BEGIN
    write_log(insert_ts_in       => insert_ts_in,
              log_severity_id_in => gc_informational_id,
              message_in         => message_in,
              username_in        => username_in,
              module_name_in     => module_name_in,
              module_action_in   => module_action_in,
              sql_errm_in        => sql_errm_in,
              sql_code_in        => sql_code_in,
              autonom_in         => autonom_in);
  END info;

  /******************************************************************************
  * Write a message of type DEBUG to the log table
  ******************************************************************************/
  PROCEDURE debug(message_in       IN t_message_lob,
                  module_name_in   IN t_module_name DEFAULT NULL,
                  module_action_in IN t_module_action DEFAULT NULL,
                  username_in      IN t_username DEFAULT USER,
                  sql_errm_in      IN t_sql_errm DEFAULT NULL,
                  sql_code_in      IN t_sql_code DEFAULT NULL,
                  insert_ts_in     IN t_insert_ts DEFAULT systimestamp,
                  autonom_in       IN PLS_INTEGER DEFAULT 1) AS
  BEGIN
    write_log(insert_ts_in       => insert_ts_in,
              log_severity_id_in => gc_debug_id,
              message_in         => message_in,
              username_in        => username_in,
              module_name_in     => module_name_in,
              module_action_in   => module_action_in,
              sql_errm_in        => sql_errm_in,
              sql_code_in        => sql_code_in,
              autonom_in         => autonom_in);
  END debug;

  /*******************************************************************************
  * Truncate table log$entry
  *******************************************************************************/
  PROCEDURE truncate_log_entry IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE log$entry';
  EXCEPTION
    WHEN OTHERS THEN
      error('Error while truncating log$entry: ' || dbms_utility.format_error_backtrace,
            module_name_in => $$PLSQL_UNIT,
            module_action_in => 'truncate_log$entry',
            sql_errm_in => SQLERRM,
            sql_code_in => SQLCODE);
      RAISE;
  END truncate_log_entry;

  /*******************************************************************************
  * Initialize
  *******************************************************************************/
  PROCEDURE initialize IS
    v_module_action t_module_action := 'initialize';
  BEGIN
    module_admin.load_and_set_config(module_name_in => $$PLSQL_UNIT);
    info(message_in => 'Initialized ' || gc_module_label, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
  END initialize;

BEGIN
  initialize;
END log_admin;
/

CREATE OR REPLACE VIEW log_entries
AS
   SELECT L.INSERT_TS,
          L.USERNAME,
          L.MESSAGE,
          l.message_lob,
          L.MODULE_NAME,
          L.MODULE_ACTION,
          L.SQL_CODE,
          l.sql_errm
     FROM log$entry l JOIN log$severity s ON (s.id = l.log_severity_id);


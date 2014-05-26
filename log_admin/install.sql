SET VERIFY ON
SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@log_severity.sql
@@log_entry.sql
@@log_admin.pck
@@context.sql

SPOOL OFF

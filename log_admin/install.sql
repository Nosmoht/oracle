SET VERIFY ON
SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@install/log_severity.sql
@@install/log_entry.sql
@@install/log_admin.pck
@@install/context.sql

SPOOL OFF

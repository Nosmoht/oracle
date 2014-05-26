SET VERIFY ON
SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@config.sql
@@install/log_severity.sql
@@install/log_entry.sql
@@install/log_entires.sql
@@install/log_admin.sql
@@install/context.sql

SPOOL OFF

QUIT

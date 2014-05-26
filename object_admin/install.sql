SET VERIFY ON
SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@config.sql
@@install/object_admin.sql
@@install/context.sql

SPOOL OFF

QUIT

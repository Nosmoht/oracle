SET ECHO ON
SET VERIFY ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@install/sql_admin.pck
@@install/context.sql

SPOOL OFF

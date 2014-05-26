SET ECHO ON
SET VERIFY ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@sql_admin.pck
@@context.sql

SPOOL OFF

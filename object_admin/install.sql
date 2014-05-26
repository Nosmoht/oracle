SET VERIFY ON
SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@object_admin.pck
@@context.sql

SPOOL OFF

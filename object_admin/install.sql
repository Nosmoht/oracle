SET VERIFY ON
SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@install/object_admin.pck
@@install/context.sql

SPOOL OFF

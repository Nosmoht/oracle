SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log
@@module.sql
@@module_config.sql
@@module_admin.pck
@@context.sql
@@configuration.sql

SPOOL OFF

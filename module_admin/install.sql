SET ECHO ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@config.sql
@@install/module.sql
@@install/module_config.sql
@@install/module_admin.pck
@@install/context.sql
@@install/configuration.sql

SPOOL OFF

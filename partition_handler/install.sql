SET ECHO ON
SET VERIFY ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@install/config.sql
@@install/oph_constants.spc
@@install/oph_types.spc
@@install/oph$tech.sql
@@install/oph$obj_type.sql
@@install/oph$obj.sql
@@install/oph$log.sql
@@install/oph$key_type.sql
@@install/oph$key.sql
@@install/oph$def.sql
@@install/oph_objects.sql
@@install/oph_config.sql
@@install/oph_tools.sql
@@install/oph_redefine.sql
@@install/oph_handler.sql
@@install/context.sql

SPOOL OFF

QUIT

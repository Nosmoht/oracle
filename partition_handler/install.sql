SET ECHO ON
SET VERIFY ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@config.sql
@@oph_constants.spc
@@oph_types.spc
@@oph$tech.sql
@@oph$obj_type.sql
@@oph$obj.sql
@@oph$log.sql
@@oph$key_type.sql
@@oph$key.sql
@@oph$def.sql
@@oph_objects.sql
@@oph_config.sql
@@oph_tools.sql
@@oph_redefine.sql
@@oph_handler.sql
@@context.sql

SPOOL OFF

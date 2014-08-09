SET ECHO ON
SET VERIFY ON
SET FEEDBACK ON
SET TIMING ON

SPOOL install.log

@@config.sql
@@install/oph_constants.sql
@@install/oph_types.sql
@@install/oph_tech.sql
@@install/oph_obj_type.sql
@@install/oph_obj.sql
@@install/oph_log.sql
@@install/oph_key_type.sql
@@install/oph_key.sql
@@install/oph_def.sql
@@install/oph_objects.sql
@@install/oph_config.sql
@@install/oph_tools.sql
@@install/oph_redefine.sql
@@install/oph.sql
@@install/context.sql

SPOOL OFF

QUIT

CREATE OR REPLACE PACKAGE module_admin IS
  /*****************************************************************************
  * Module Admin
  *
  * Author:        Thomas Krahn
  * Date:          2013-08-09
  * Version:       0.7.2
  *****************************************************************************/

  /*****************************************************************************
  * Types
  *****************************************************************************/
  SUBTYPE t_module_id IS module.id%TYPE;
  SUBTYPE t_module_name IS module.name%TYPE;
  SUBTYPE t_module_enabled IS module.enabled%TYPE;
  SUBTYPE t_module_label IS VARCHAR2(38 CHAR);
  SUBTYPE t_module_version IS VARCHAR2(8 CHAR);
  SUBTYPE t_module_action IS VARCHAR2(64 CHAR);
  SUBTYPE t_context_name IS module.context_name%TYPE;
  SUBTYPE t_parameter_name IS module_config.parameter%TYPE;
  SUBTYPE t_parameter_value IS module_config.value%TYPE;

  /*****************************************************************************
  * Constants
  *****************************************************************************/
  gc_module_version CONSTANT t_module_version := '0.7.2';
  gc_module_label   CONSTANT t_module_label := $$PLSQL_UNIT || ' v' || gc_module_version;

  /*****************************************************************************
  * Add a module to the registration
  *****************************************************************************/
  PROCEDURE register_module(module_name_in IN t_module_name, context_name_in IN t_context_name, enabled_in IN t_module_enabled DEFAULT 1);

  /*****************************************************************************
  * Return the ID of a registered module, else NULL.
  *****************************************************************************/
  FUNCTION load_module_id(module_name_in IN t_module_name) RETURN t_module_id;

  /*****************************************************************************
  * Return CONTEXT_NAME of a registered module, else NULL.
  *****************************************************************************/
  FUNCTION load_context_name(module_name_in IN t_module_name) RETURN t_context_name;

  /*****************************************************************************
  * Update CONTEXT_NAME of a registered module
  *****************************************************************************/
  PROCEDURE save_context_name(module_name_in IN t_module_name, context_name_in IN t_context_name);

  /*****************************************************************************
  * Return VALUE of a module's parameter
  *****************************************************************************/
  FUNCTION load_parameter_value(module_name_in IN t_module_name, parameter_name_in IN t_parameter_name) RETURN t_parameter_value;

  /*****************************************************************************
  * Write an attribute and it's value of a module to config table
  *****************************************************************************/
  PROCEDURE save_parameter_value(module_name_in IN t_module_name, parameter_in IN t_parameter_name, value_in IN t_parameter_value);

  /*****************************************************************************
  * Set an attribute and it's value for a module in the assigned context
  *****************************************************************************/
  PROCEDURE set_parameter_value(context_name_in IN t_context_name, parameter_in IN t_parameter_name, value_in IN t_parameter_value);

  /*****************************************************************************
  * Return the value of a modules attributes from the context
  *****************************************************************************/
  FUNCTION get_parameter_value(context_name_in IN t_context_name, parameter_in IN t_parameter_name) RETURN t_parameter_value;

  /*****************************************************************************
  * Set value for parameters in module's context
  *****************************************************************************/
  PROCEDURE set_module_value(module_name_in IN t_module_name, parameter_in IN t_parameter_name, value_in IN t_parameter_value);

  /*****************************************************************************
  * Get value of parameters from module's context
  *****************************************************************************/
  FUNCTION get_module_value(module_name_in IN t_module_name, parameter_in IN t_parameter_name) RETURN t_parameter_value;

  /*****************************************************************************
  * Load and assign the configuration of a module to it's context
  *****************************************************************************/
  PROCEDURE load_and_set_config(module_name_in IN t_module_name);

  /*****************************************************************************
  * Get the configuration from a module's context and save it to config table
  *****************************************************************************/
  PROCEDURE get_and_save_config(module_name_in IN t_module_name);
END module_admin;
/

CREATE OR REPLACE PACKAGE BODY module_admin IS
  /*****************************************************************************
  * Global Variables
  *****************************************************************************/
  g_context_name           t_context_name := NULL;
  g_parameter_context_name t_parameter_name := 'CTX';
  g_parameter_module_id    t_parameter_name := 'ID';

  /*****************************************************************************
  * Exceptions
  *****************************************************************************/
  e_module_not_registered EXCEPTION; -- ORA-20001 Modul "%s" not registered
  PRAGMA EXCEPTION_INIT(e_module_not_registered, -20001);
  e_module_already_registered EXCEPTION; -- ORA-20002 Module "%s" already registered
  PRAGMA EXCEPTION_INIT(e_module_already_registered, -20002);
  e_parameter_not_configured EXCEPTION; -- ORA-20003 Parameter "%s" of module "%s" not configured
  PRAGMA EXCEPTION_INIT(e_parameter_not_configured, -20003);

  /*****************************************************************************
  * Insert a new module into table MODULE
  *****************************************************************************/
  PROCEDURE add_module(module_name_in IN t_module_name, context_name_in IN t_context_name, enabled_in IN t_module_enabled DEFAULT 1, id_io IN OUT t_module_id) IS
  BEGIN
    INSERT INTO module
      (id, NAME, context_name, enabled)
    VALUES
      (nvl(id_io, module_id_seq.nextval), upper(module_name_in), upper(context_name_in), enabled_in)
    RETURNING id INTO id_io;
  EXCEPTION
    WHEN dup_val_on_index THEN
      RAISE e_module_already_registered;
  END add_module;

  /*****************************************************************************
  * Register a new module
  *****************************************************************************/
  PROCEDURE register_module(module_name_in IN t_module_name, context_name_in IN t_context_name, enabled_in IN t_module_enabled DEFAULT 1) IS
    n_module_id t_module_id := NULL;
  BEGIN
    add_module(module_name_in => upper(module_name_in), context_name_in => upper(context_name_in), enabled_in => enabled_in, id_io => n_module_id);
  EXCEPTION
    WHEN e_module_already_registered THEN
      raise_application_error(-20002, 'Module ' || module_name_in || ' already registered');
  END register_module;

  /*****************************************************************************
  * Return ID of a registered module, else NULL.
  *****************************************************************************/
  FUNCTION load_module_id(module_name_in IN t_module_name) RETURN t_module_id IS
    n_result t_module_id;
  BEGIN
    SELECT m.id INTO n_result FROM module m WHERE NAME = upper(module_name_in);
    RETURN n_result;
  EXCEPTION
    WHEN no_data_found THEN
      raise_application_error(-20001, ' Module ' || module_name_in || ' not registered');
  END load_module_id;

  /*****************************************************************************
  * Get the ID of a module from module_admin's context. If this is not available,
  * load it from module table
  ********************************************************************************/
  FUNCTION get_module_id(module_name_in IN t_module_name) RETURN t_module_id IS
  BEGIN
    RETURN nvl(get_parameter_value(context_name_in => g_context_name, parameter_in => upper(module_name_in) || '.' || g_parameter_module_id),
               load_module_id(module_name_in => module_name_in));
  END get_module_id;

  /*****************************************************************************
  * Return CONTEXT_NAME of a registered module, else NULL.
  *****************************************************************************/
  FUNCTION load_context_name(module_name_in IN t_module_name) RETURN t_context_name IS
    v_result t_context_name;
  BEGIN
    SELECT m.context_name INTO v_result FROM module m WHERE m.name = upper(module_name_in);
    RETURN v_result;
  EXCEPTION
    WHEN no_data_found THEN
      raise_application_error(-20001, ' Module ' || module_name_in || ' not registered');
  END load_context_name;

  /*****************************************************************************
  * Update CONTEXT_NAME of a registered module
  *****************************************************************************/
  PROCEDURE save_context_name(module_name_in IN t_module_name, context_name_in IN t_context_name) IS
    n_module_id t_module_id := get_module_id(module_name_in => module_name_in);
  BEGIN
    UPDATE module m SET m.context_name = upper(context_name_in) WHERE m.id = n_module_id;
  EXCEPTION
    WHEN e_module_not_registered THEN
      raise_application_error(-20001, ' Module ' || module_name_in || ' not registered');
  END save_context_name;

  /*****************************************************************************
  * Get CONTEXT_NAME of the module from module_admin's context. If this is not available, load it from config table.
  *****************************************************************************/
  FUNCTION get_context_name(module_name_in IN t_module_name) RETURN t_context_name IS
  BEGIN
    RETURN nvl(get_parameter_value(context_name_in => g_context_name, parameter_in => upper(module_name_in) || '.' || g_parameter_context_name),
               load_context_name(module_name_in => module_name_in));
  END get_context_name;

  /*****************************************************************************
  * Return VALUE of a module's parameter
  *****************************************************************************/
  FUNCTION load_parameter_value(module_name_in IN t_module_name, parameter_name_in IN t_parameter_name) RETURN t_parameter_value IS
    n_module_id t_module_id := get_module_id(module_name_in => module_name_in);
    v_result    t_parameter_value;
  BEGIN
    SELECT mc.value
      INTO v_result
      FROM module_config mc
     WHERE mc.module_id = n_module_id
       AND mc.parameter = parameter_name_in;
    RETURN v_result;
  EXCEPTION
    WHEN no_data_found THEN
      raise_application_error(-20003, 'Parameter ' || parameter_name_in || ' of module ' || module_name_in || ' not configured');
    WHEN e_module_not_registered THEN
      raise_application_error(-20001, ' Module ' || module_name_in || ' not registered');
  END load_parameter_value;

  /*****************************************************************************
  * Write an attribute and it's value of a module to config table
  *****************************************************************************/
  PROCEDURE save_parameter_value(module_name_in IN t_module_name, parameter_in IN t_parameter_name, value_in IN t_parameter_value) IS
    n_module_id t_module_id := get_module_id(module_name_in => module_name_in);
  BEGIN
    MERGE INTO module_config mc
    USING (SELECT n_module_id AS module_id, upper(parameter_in) AS parameter FROM dual) s
    ON (mc.module_id = s.module_id AND mc.parameter = s.parameter)
    WHEN MATCHED THEN
      UPDATE SET mc.value = value_in
    WHEN NOT MATCHED THEN
      INSERT (module_id, parameter, VALUE) VALUES (s.module_id, s.parameter, value_in);
  EXCEPTION
    WHEN e_module_not_registered THEN
      raise_application_error(-20001, ' Module ' || module_name_in || ' not registered');
  END save_parameter_value;

  /*****************************************************************************
  * Set an attribute and it's value for a module in module's context
  *****************************************************************************/
  PROCEDURE set_parameter_value(context_name_in IN t_context_name, parameter_in IN t_parameter_name, value_in IN t_parameter_value) IS
  BEGIN
    dbms_session.set_context(namespace => context_name_in, attribute => parameter_in, VALUE => value_in);
  END set_parameter_value;

  /*****************************************************************************
  * Get the value of a modules parameter from context
  *****************************************************************************/
  FUNCTION get_parameter_value(context_name_in IN t_context_name, parameter_in IN t_parameter_name) RETURN t_parameter_value IS
  BEGIN
    RETURN sys_context(namespace => context_name_in, attribute => parameter_in);
  END get_parameter_value;

  /*****************************************************************************
  * Set value for parameters in module's context
  *****************************************************************************/
  PROCEDURE set_module_value(module_name_in IN t_module_name, parameter_in IN t_parameter_name, value_in IN t_parameter_value) IS
    v_context_name t_context_name := get_context_name(module_name_in => module_name_in);
  BEGIN
    set_parameter_value(context_name_in => v_context_name, parameter_in => parameter_in, value_in => value_in);
  END set_module_value;

  /*****************************************************************************
  * Get value of parameters from module's context
  *****************************************************************************/
  FUNCTION get_module_value(module_name_in IN t_module_name, parameter_in IN t_parameter_name) RETURN t_parameter_value IS
    v_context_name t_context_name := get_context_name(module_name_in => module_name_in);
  BEGIN
    RETURN get_parameter_value(context_name_in => v_context_name, parameter_in => parameter_in);
  END get_module_value;

  /*****************************************************************************
  * Load and assign the configuration of a module to it's context
  *****************************************************************************/
  PROCEDURE load_and_set_config(module_name_in IN t_module_name) IS
    --    v_module_action log_admin.t_module_action := 'load_and_set_config';
    n_module_id    t_module_id := get_module_id(module_name_in => module_name_in);
    v_context_name t_context_name := get_context_name(module_name_in => module_name_in);
  BEGIN
    --    log_admin.debug('Loading configuration of module: ' || module_name_in, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
    FOR i IN (SELECT mc.parameter, mc.value FROM module_config mc WHERE mc.module_id = n_module_id) LOOP
      set_parameter_value(context_name_in => v_context_name, parameter_in => i.parameter, value_in => i.value);
    END LOOP;
    --    log_admin.info('Configuration loaded for module: ' || module_name_in, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
  EXCEPTION
    WHEN OTHERS THEN
      /*      log_admin.error('Could not load and assign configuration of module: ' || module_name_in,
      module_name_in => $$PLSQL_UNIT,
      module_action_in => v_module_action,
      sql_errm_in => SQLERRM,
      sql_code_in => SQLCODE);*/
      RAISE;
  END load_and_set_config;

  /*****************************************************************************
  * Get the configuration from a module's context and save it to config table
  *****************************************************************************/
  PROCEDURE get_and_save_config(module_name_in IN t_module_name) IS
    --    v_module_action log_admin.t_module_action := 'get_and_save_config';
    n_module_id    t_module_id := get_module_id(module_name_in => module_name_in);
    v_context_name t_context_name;
  BEGIN
    --    log_admin.debug('Saving configuration of module: ' || module_name_in, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
    -- Get the CONTEXT_NAME of the module from module_admin's context. If this is not available, load it from config table.
    v_context_name := nvl(get_parameter_value(context_name_in => g_context_name, parameter_in => upper(module_name_in) || '.' || g_parameter_context_name),
                          load_context_name(module_name_in => module_name_in));
    FOR i IN (SELECT mc.parameter FROM module_config mc WHERE mc.module_id = n_module_id) LOOP
      save_parameter_value(module_name_in => module_name_in,
                           parameter_in   => i.parameter,
                           value_in       => get_parameter_value(context_name_in => v_context_name, parameter_in => i.parameter));
    END LOOP;
    COMMIT;
    --    log_admin.info('Configuration saved of module: ' || module_name_in, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
  END get_and_save_config;

  /*****************************************************************************
  * Initialize
  *****************************************************************************/
  PROCEDURE initialize IS
    --    v_module_action log_admin.t_module_actoin := 'initialize';
  BEGIN
    -- Get own context name to store module configuration
    g_context_name := load_context_name(module_name_in => $$PLSQL_UNIT);
    --    log_admin.debug('Initializing ' || gc_module_label, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
    FOR i IN (SELECT m.id AS module_id, m.name AS module_name, m.context_name FROM module m WHERE m.enabled = 1) LOOP
      -- Set parameter <MODULE_NAME>.CONTEXT_NAME for the module in module_admin's context
      set_parameter_value(context_name_in => g_context_name, parameter_in => i.module_name || '.' || g_parameter_context_name, value_in => i.context_name);
      -- Set parameter <MODULE_NAME>.MODULE_ID for the module in module_admin's context
      set_parameter_value(context_name_in => g_context_name, parameter_in => i.module_name || '.' || g_parameter_module_id, value_in => i.module_id);
    END LOOP;
    --    log_admin.info('Initialized ' || gc_module_label, module_name_in => $$PLSQL_UNIT, module_action_in => v_module_action);
  EXCEPTION
    WHEN OTHERS THEN
      /*      log_admin.critical('Initialization failed',
      module_name_in         => $$PLSQL_UNIT,
      module_action_in       => v_module_action,
      sql_errm_in            => SQLERRM,
      sql_code_in            => SQLCODE);*/
      RAISE;
  END initialize;

BEGIN
  initialize;
END module_admin;
/

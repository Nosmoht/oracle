DECLARE
   v_module_name   module.name%TYPE := 'MODULE_ADMIN';
BEGIN
   module_admin.register_module (module_name_in    => v_module_name,
                                 context_name_in   => 'MODULE_ADMIN_CTX');
   module_admin.save_parameter_value (module_name_in   => v_module_name,
                                      parameter_in     => 'LOG_SEVERITY_ID',
                                      value_in         => 7);
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
      RAISE;
END;
/
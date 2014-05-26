CREATE OR REPLACE CONTEXT log_admin_ctx USING module_admin;

BEGIN
   module_admin.register_module (module_name_in    => 'LOG_ADMIN',
                                 context_name_in   => 'LOG_ADMIN_CTX',
                                 enabled_in        => 1);
   COMMIT;
END;
/

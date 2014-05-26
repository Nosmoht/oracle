CREATE OR REPLACE CONTEXT object_admin_ctx using module_admin;

BEGIN
   module_admin.register_module(module_name_in => 'OBJECT_ADMIN', context_name_in => 'OBJECT_ADMIN_CTX', enabled_in => 1);
   commit;
END;
/

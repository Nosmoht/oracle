CREATE OR REPLACE CONTEXT oph_ctx USING module_admin;

BEGIN
   module_admin.register_module(module_name_in => 'OPH', context_name_in => 'OPH_CTX', enabled_in => 1);
   module_admin.register_module(module_name_in => 'OPH_TOOLS', context_name_in => 'OPH_CTX', enabled_in => 1);
   module_admin.register_module(module_name_in => 'OPH_REDEFINE', context_name_in => 'OPH_CTX', enabled_in => 1);
   commit;
END;
/

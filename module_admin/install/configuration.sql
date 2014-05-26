INSERT INTO module (id, NAME, context_name, enabled) VALUES (1, 'MODULE_ADMIN', 'MODULE_ADMIN_CTX', 1);
INSERT INTO module_config (module_id, parameter, VALUE) VALUES (1, 'LOG_SEVERITY_ID', 7);
COMMIT;


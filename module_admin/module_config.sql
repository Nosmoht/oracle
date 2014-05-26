CREATE TABLE module_config
(
   module_id   NUMBER (38, 0) CONSTRAINT module_config_module_id_nn NOT NULL,
   parameter   VARCHAR2 (255 CHAR)
                  CONSTRAINT module_config_parameter_nn NOT NULL,
   VALUE       VARCHAR (255 CHAR) CONSTRAINT module_config_value_nn NOT NULL,
   CONSTRAINT module_config_module_fk FOREIGN KEY
      (module_id)
       REFERENCES module (id) ON DELETE CASCADE
)
TABLESPACE &DATA_TBS.;

CREATE UNIQUE INDEX module_config_mod_parameter_ux
   ON module_config (module_id, parameter)
   TABLESPACE &INDEX_TBS.;

ALTER TABLE module_config ADD CONSTRAINT module_config_pk PRIMARY KEY (module_id, parameter);
CREATE TABLE module
(
   id             NUMBER (38, 0) CONSTRAINT module_id_nn NOT NULL,
   name           VARCHAR2 (30 CHAR) CONSTRAINT module_name_nn NOT NULL,
   context_name   VARCHAR2 (30 CHAR)
                     CONSTRAINT module_context_name_nn NOT NULL,
   enabled        NUMBER (1, 0) CONSTRAINT module_enabled_nn NOT NULL,
   CONSTRAINT module_enabled_ck CHECK (enabled IN (0, 1))
)
TABLESPACE &DATA_TBS.;

CREATE UNIQUE INDEX module_id_ux
   ON module (id)
   TABLESPACE &INDEX_TBS.;

CREATE UNIQUE INDEX module_name_ux
   ON module (name)
   TABLESPACE &INDEX_TBS.;

ALTER TABLE module ADD CONSTRAINT module_pk PRIMARY KEY (id);
ALTER TABLE module ADD CONSTRAINT module_name_uk UNIQUE (name);

CREATE SEQUENCE module_id_seq START WITH 1000 INCREMENT BY 1 NOCACHE ORDER;

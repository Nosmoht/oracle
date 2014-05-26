CREATE TABLE OPH$OBJ_TYPE
(
   ID            NUMBER (38) CONSTRAINT OPH$OBJ_TYPE_ID_NN NOT NULL,
   NAME          VARCHAR2 (30 CHAR) CONSTRAINT OPH$OBJ_TYPE_NAME_NN NOT NULL,
   DESCRIPTION   VARCHAR2 (255 CHAR)
                    CONSTRAINT OPH$OBJ_TYPE_DESCRIPTION_NN NOT NULL
)
TABLESPACE &DATA_TBS.;

INSERT INTO OPH$OBJ_TYPE (id, name, description)
     VALUES (1, 'TABLE', 'Partition definition is for a table');

INSERT INTO OPH$OBJ_TYPE (id, name, description)
     VALUES (2, 'INDEX', 'Partition definition is for an index');

ALTER TABLE OPH$OBJ_TYPE
READ ONLY;

CREATE UNIQUE INDEX OPH$OBJ_TYPE_ID_UX
   ON OPH$OBJ_TYPE (ID)
   TABLESPACE &INDEX_TBS.;

CREATE UNIQUE INDEX OPH$OBJ_TYPE_NAME_UX
   ON OPH$OBJ_TYPE (NAME)
   TABLESPACE &INDEX_TBS.;

ALTER TABLE OPH$OBJ_TYPE ADD
  CONSTRAINT OPH$OBJ_TYPE_PK
  PRIMARY KEY
  (ID);

ALTER TABLE OPH$OBJ_TYPE ADD CONSTRAINT OPH$OBJ_TYPE_NAME_PK
  UNIQUE (NAME);
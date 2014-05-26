CREATE TABLE oph$key_type
(
   ID            NUMBER (38) CONSTRAINT oph$key_type_ID_NN NOT NULL,
   NAME          VARCHAR2 (12 CHAR) CONSTRAINT oph$key_type_NAME_NN NOT NULL,
   DESCRIPTION   VARCHAR2 (255 CHAR)
                    CONSTRAINT oph$key_type_DESCRIPTION_NN NOT NULL
)
TABLESPACE &DATA_TBS.;

INSERT INTO oph$key_type (id, name, description)
     VALUES (1, 'PARTITION', 'Partition key');

INSERT INTO oph$key_type (id, name, description)
     VALUES (2, 'SUBPARTITION', 'Subpartition key');

ALTER TABLE oph$key_type
READ ONLY;

CREATE UNIQUE INDEX oph$key_type_ID_UX
   ON oph$key_type (ID)
   TABLESPACE &INDEX_TBS.;

CREATE UNIQUE INDEX oph$key_type_NAME_UX
   ON oph$key_type (NAME)
   TABLESPACE &INDEX_TBS.;

ALTER TABLE oph$key_type ADD  CONSTRAINT oph$key_type_PK
  PRIMARY KEY
  (ID);
  
ALTER TABLE oph$key_type ADD  CONSTRAINT oph$key_type_NAME_UK
  UNIQUE (NAME);
CREATE TABLE oph$tech
(
   ID            NUMBER (38) CONSTRAINT oph$tech_ID_NN NOT NULL,
   NAME          VARCHAR2 (10 CHAR) CONSTRAINT oph$tech_NAME_NN NOT NULL,
   DESCRIPTION   VARCHAR2 (255 CHAR)
                    CONSTRAINT oph$tech_DESCRIPTION_NN NOT NULL
)
TABLESPACE &DATA_TBS.;

INSERT INTO oph$tech (id, name, description)
     VALUES (1, 'LIST', 'Partitioned by List');

INSERT INTO oph$tech (id, name, description)
     VALUES (2, 'RANGE', 'Partitioned by Range');

INSERT INTO oph$tech (id, name, description)
     VALUES (3, 'HASH', 'Partitioned by Hash');

INSERT INTO oph$tech (id, name, description)
     VALUES (4, 'INTERVAL', 'Partitioned by Interval');

INSERT INTO oph$tech (id, name, description)
     VALUES (5, 'REFERENCE', 'Partitioned by Reference');

ALTER TABLE oph$tech
READ ONLY;

COMMENT ON TABLE oph$tech IS 'Partition technique';

COMMENT ON COLUMN oph$tech.ID IS 'Technical unique identifier';

COMMENT ON COLUMN oph$tech.NAME IS 'Name of the partitionm technique';

COMMENT ON COLUMN oph$tech.DESCRIPTION IS 'Description';



CREATE UNIQUE INDEX oph$tech_ID_UX
   ON oph$tech (ID)
   TABLESPACE &INDEX_TBS.;

CREATE UNIQUE INDEX oph$tech_NAME_UX
   ON oph$tech (NAME)
   TABLESPACE &INDEX_TBS.;

ALTER TABLE oph$tech ADD
  CONSTRAINT oph$tech_PK
  PRIMARY KEY
  (ID);

ALTER TABLE oph$tech ADD CONSTRAINT oph$tech_NAME_UK
  UNIQUE (NAME);
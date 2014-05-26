CREATE TABLE log_entry
(
   id                NUMBER (38, 0) CONSTRAINT log_entry_id_nn NOT NULL,
   log_severity_id   NUMBER (2, 0)
                        CONSTRAINT log_entry_log_severity_id_nn NOT NULL,
   insert_ts         TIMESTAMP WITH LOCAL TIME ZONE
                        CONSTRAINT log_entry_insert_ts_nn NOT NULL,
   username          VARCHAR2 (30 CHAR)
                        CONSTRAINT log_entry_username_nn NOT NULL,
   MESSAGE           VARCHAR2 (4000 CHAR)
                        CONSTRAINT log_entry_message_nn NOT NULL,
   module_name       VARCHAR2 (255 CHAR),
   module_action     VARCHAR2 (255 CHAR),
   sql_errm          VARCHAR2 (4000 CHAR),
   sql_code          NUMBER (5, 0),
   message_lob       CLOB
)
TABLESPACE &DATA_TBS.;


CREATE UNIQUE INDEX log_entry_id_ux
   ON log_entry (id)
   TABLESPACE &INDEX_TBS.;

ALTER TABLE log_entry ADD CONSTRAINT log_entry_pk PRIMARY KEY ( id);

CREATE SEQUENCE log_entry_id_seq START WITH 1
                                 INCREMENT BY 1
                                 MAXVALUE 99999999999999999999999999999999999999
                                 CYCLE
                                 CACHE 1000
                                 NOORDER;

ALTER TABLE log_entry ADD CONSTRAINT log_entry_log_severity_fk FOREIGN KEY (log_severity_id) REFERENCES log_severity (id) ON DELETE CASCADE;
CREATE TABLE oph$log
(
   obj_id     NUMBER (38, 0) CONSTRAINT oph$log_obj_id_nn NOT NULL,
   start_ts   TIMESTAMP WITH LOCAL TIME ZONE
                 CONSTRAINT oph$log_start_ts_nn NOT NULL,
   end_ts     TIMESTAMP WITH LOCAL TIME ZONE
                 CONSTRAINT oph$log_end_ts_nn NOT NULL,
   duration   INTERVAL DAY TO SECOND GENERATED ALWAYS AS (end_ts - start_ts)
)
TABLESPACE &DATA_TBS;

CREATE UNIQUE INDEX oph$log_obj_id_start_ts_ux
   ON oph$log (obj_id, start_ts)
   COMPRESS 1
   TABLESPACE &INDEX_TBS;

ALTER TABLE oph$log ADD CONSTRAINT oph$log_pk PRIMARY KEY (obj_id, start_ts);

ALTER TABLE oph$log ADD CONSTRAINT oph$log_p_obj_fk FOREIGN KEY (obj_id) REFERENCES oph$obj (id);

CREATE OR REPLACE TRIGGER oph$obj_bur
   BEFORE UPDATE OF last_run_start_ts
   ON oph$obj
   FOR EACH ROW
   WHEN (old.last_run_start_ts IS NOT NULL)
BEGIN
   INSERT INTO oph$log (obj_id, start_ts, end_ts)
        VALUES (:old.id, :old.last_run_start_ts, :old.last_run_end_ts);
END oph$obj_bur;
/
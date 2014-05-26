CREATE TABLE log_severity
(
   id                    NUMBER (2, 0) CONSTRAINT log_severity_id_nn NOT NULL,
   name                  VARCHAR2 (13 CHAR) CONSTRAINT log_severity_name_nn NOT NULL,
   description           VARCHAR2 (40 CHAR)
                            CONSTRAINT log_severity_description_nn NOT NULL,
   general_description   VARCHAR2 (255 CHAR)
                            CONSTRAINT log_severity_general_desc_nn NOT NULL,
   CONSTRAINT log_severity_pk PRIMARY KEY (id),
   CONSTRAINT log_severity_name_uk UNIQUE (name)
)
ORGANIZATION INDEX
TABLESPACE &DATA_TBS.;

COMMENT ON TABLE log_severity IS 'Log severity like descripted in RFC 5424';
COMMENT ON COLUMN log_severity.id IS 'Unique identifier';
COMMENT ON COLUMN log_severity.name IS 'Unique Name';
COMMENT ON COLUMN log_severity.description IS 'Short Description';
COMMENT ON COLUMN log_severity.general_description IS 'General Description';

INSERT INTO log_severity (id,
                          name,
                          description,
                          general_description)
        VALUES (
                  1,
                  'Emergency',
                  'System is unusable.',
                  'A "panic" condition usually affecting multiple apps/servers/sites. At this level it would usually notify all tech staff on call.');

INSERT INTO log_severity (id,
                          name,
                          description,
                          general_description)
        VALUES (
                  2,
                  'Alert',
                  'Action must be taken immediately.',
                  'Should be corrected immediately, therefore notify staff who can fix the problem. An example would be the loss of a backup ISP connection.');

INSERT INTO log_severity (id,
                          name,
                          description,
                          general_description)
        VALUES (
                  3,
                  'Critical',
                  'Critical conditions.',
                  'Should be corrected immediately, but indicates failure in a primary system, an example is a loss of primary ISP connection.');

INSERT INTO log_severity (id,
                          name,
                          description,
                          general_description)
        VALUES (
                  4,
                  'Error',
                  'Error conditions.',
                  'Non-urgent failures, these should be relayed to developers or admins; each item must be resolved within a given time.');

INSERT INTO log_severity (id,
                          name,
                          description,
                          general_description)
        VALUES (
                  5,
                  'Warning',
                  'Warning conditions.',
                  'Warning messages, not an error, but indication that an error will occur if action is not taken, e.g. file system 85% full - each item must be resolved within a given time.');

INSERT INTO log_severity (id,
                          name,
                          description,
                          general_description)
        VALUES (
                  6,
                  'Notice',
                  'Normal but significant condition.',
                  'Events that are unusual but not error conditions - might be summarized in an email to developers or admins to spot potential problems - no immediate action required.');

INSERT INTO log_severity (id,
                          name,
                          description,
                          general_description)
        VALUES (
                  7,
                  'Informational',
                  'Informational messages.',
                  'Normal operational messages - may be harvested for reporting, measuring throughput, etc. - no action required.');

INSERT INTO log_severity (id,
                          name,
                          description,
                          general_description)
        VALUES (
                  8,
                  'Debug',
                  'Debug-level messages.',
                  'Info useful to developers for debugging the application, not useful during operations.');

ALTER TABLE log_severity READ ONLY;
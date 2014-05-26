CREATE OR REPLACE VIEW OPH_OBJECT
AS
     SELECT o.id AS object_id,
            o.enabled,
            o.order#,
            ot.name AS object_type,
            o.owner AS object_owner,
            o.name object_name,
            ot.name || ' "' || o.owner || '"."' || o.name || '"' AS label_name,
            pk.column_name AS partition_key,
            DECODE (
               ot.name,
               'TABLE', (SELECT tc.data_type
                           FROM dba_tab_columns tc
                          WHERE     tc.owner = o.owner
                                AND tc.table_name = o.name
                                AND tc.column_name = pk.column_name),
               'INDEX', (SELECT tc.data_type
                           FROM dba_tab_columns tc
                          WHERE (tc.owner, tc.table_name, tc.column_name) =
                                   (SELECT ic.table_owner,
                                           ic.table_name,
                                           ic.column_name
                                      FROM dba_ind_columns ic
                                     WHERE     ic.index_owner = o.owner
                                           AND ic.index_name = o.name
                                           AND ic.column_name = pk.column_name)),
               NULL)
               AS partition_key_data_type,
            (SELECT pt.name
               FROM oph$tech pt
              WHERE pt.id = pk.tech_id)
               AS partition_technique,
            sk.column_name AS subpartition_key,
            DECODE (
               ot.name,
               'TABLE', (SELECT tc.data_type
                           FROM dba_tab_columns tc
                          WHERE     tc.owner = o.owner
                                AND tc.table_name = o.name
                                AND tc.column_name = sk.column_name),
               'INDEX', (SELECT tc.data_type
                           FROM dba_tab_columns tc
                          WHERE (tc.owner, tc.table_name, tc.column_name) =
                                   (SELECT ic.table_owner,
                                           ic.table_name,
                                           ic.column_name
                                      FROM dba_ind_columns ic
                                     WHERE     ic.index_owner = o.owner
                                           AND ic.index_name = o.name
                                           AND ic.column_name = sk.column_name)),
               NULL)
               AS subpartition_key_data_type,
            (SELECT pt.name
               FROM oph$tech pt
              WHERE pt.id = sk.tech_id)
               AS subpartition_technique
       FROM oph$obj o
            JOIN oph$obj_type ot ON (ot.id = o.type_id)
            JOIN oph$key pk ON (pk.obj_id = o.id AND pk.type_id = 1)
            LEFT OUTER JOIN oph$key sk ON (sk.obj_id = o.id AND sk.type_id = 2)
   ORDER BY o.owner, o.name;

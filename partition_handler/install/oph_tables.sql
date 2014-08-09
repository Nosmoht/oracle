CREATE OR REPLACE VIEW oph_tables
AS
   SELECT o.owner,
          o.name AS table_name,
          (SELECT COUNT (1)
             FROM dba_tables t
            WHERE t.owner = o.owner AND t.table_name = o.name)
             AS table_exists,
          PK.COLUMN_NAME AS partition_key,
          pkt.name AS partition_technique,
          (SELECT dpkc.column_name
             FROM dba_part_key_columns dpkc
            WHERE     dpkc.owner = o.owner
                  AND DPKC.OBJECT_TYPE = 'TABLE'
                  AND dpkc.name = O.NAME
                  AND dpkc.column_position = 1)
             AS current_partition_key,
          sk.column_name AS subpartition_key,
          skt.name AS subpartition_technique,
          (SELECT dpkc.column_name
             FROM dba_part_key_columns dpkc
            WHERE     dpkc.owner = o.owner
                  AND DPKC.OBJECT_TYPE = 'TABLE'
                  AND dpkc.name = O.NAME
                  AND dpkc.column_position = 2)
             AS current_subpartition_key
     FROM oph$obj o
          LEFT OUTER JOIN oph$key pk ON (pk.obj_id = O.ID AND PK.TYPE_ID = 1)
          LEFT OUTER JOIN oph$tech pkt ON (pkt.id = pk.type_id)
          LEFT OUTER JOIN oph$key sk ON (sk.obj_id = o.id AND sk.type_id = 2)
          LEFT OUTER JOIN oph$tech skt ON (skt.id = sk.type_id)
    WHERE o.type_id = 1;

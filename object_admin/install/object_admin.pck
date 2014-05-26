CREATE OR REPLACE PACKAGE object_admin IS
  /****************************************************************************
  * Object Admin
  *
  * Author:    Thomas Krahn
  * Date:      2014-05-05
  * Version:   0.11.8
  *
  * Requires:  sql_admin    v0.3.3
  *            module_admin v0.7.8
  ****************************************************************************/
  gc_module_version CONSTANT module_admin.t_module_version := '0.11.8';
  gc_module_label   CONSTANT module_admin.t_module_label := $$PLSQL_UNIT || ' v' || gc_module_version;

  /*****************************************************************************
  * Return 1 if the object does exist, else 0.
  *****************************************************************************/
  FUNCTION is_object_existing(owner_in       IN dba_objects.owner%TYPE,
                              object_type_in IN dba_objects.object_type%TYPE,
                              object_name_in IN dba_objects.object_name%TYPE) RETURN NUMBER;

  /******************************************************************************/
  /* Drop an object
  /******************************************************************************/
  PROCEDURE drop_object(owner_in IN dba_objects.owner%TYPE, object_name_in IN dba_objects.object_name%TYPE, object_type_in IN dba_objects.object_type%TYPE);

  /******************************************************************************/
  /* Return 1 if the table is partitioned, else 0.
  /******************************************************************************/
  FUNCTION is_table_partitioned(owner_in IN dba_tables.owner%TYPE, table_name_in IN dba_tables.table_name%TYPE) RETURN NUMBER;

  /******************************************************************************/
  /* Return 1 if the index is partitioned, else 0.
  /******************************************************************************/
  FUNCTION is_index_partitioned(owner_in IN dba_indexes.owner%TYPE, index_name_in IN dba_indexes.table_name%TYPE) RETURN NUMBER;

  /******************************************************************************/
  /* Return 1 if the object is partitioned, else 0.
  /******************************************************************************/
  FUNCTION is_object_partitioned(owner_in       IN dba_objects.owner%TYPE,
                                 object_name_in IN dba_objects.object_name%TYPE,
                                 object_type_in IN dba_objects.object_type%TYPE) RETURN NUMBER;

  /******************************************************************************/
  /* Return 1 if the object partition key is the provided one, else 0.
  /******************************************************************************/
  FUNCTION is_object_partition_key(owner_in         IN dba_part_key_columns.owner%TYPE,
                                   object_name_in   IN dba_part_key_columns.name%TYPE,
                                   object_type_in   IN dba_part_key_columns.object_type%TYPE,
                                   partition_key_in IN dba_part_key_columns.column_name%TYPE) RETURN NUMBER;

  /******************************************************************************/
  /* Return 1 if the object subpartition key is the provided one, else 0.
  /******************************************************************************/
  FUNCTION is_object_subpartition_key(owner_in            IN dba_subpart_key_columns.owner%TYPE,
                                      object_name_in      IN dba_subpart_key_columns.name%TYPE,
                                      object_type_in      IN dba_subpart_key_columns.object_type%TYPE,
                                      subpartition_key_in IN dba_subpart_key_columns.column_name%TYPE) RETURN NUMBER;

  /******************************************************************************/
  /* Return the value of DBA_TABLES.DEGREE
  /******************************************************************************/
  FUNCTION get_table_degree(owner_in IN dba_tables.owner%TYPE, table_name_in IN dba_tables.table_name%TYPE) RETURN dba_tables.degree%TYPE;

  /******************************************************************************/
  /* Return the value of DBA_INDEXES.DEGREE
  /******************************************************************************/
  FUNCTION get_index_degree(owner_in IN dba_indexes.owner%TYPE, index_name_in IN dba_indexes.index_name%TYPE) RETURN dba_indexes.degree%TYPE;

  /******************************************************************************/
  /* Return the name of the foreign key on this column.
  /*
  /* Hint: Only foreign keys on a single column are supported
  /******************************************************************************/
  FUNCTION get_foreign_key_name_on_column(owner_in       IN dba_cons_columns.owner%TYPE,
                                          table_name_in  IN dba_cons_columns.table_name%TYPE,
                                          column_name_in IN dba_cons_columns.column_name%TYPE) RETURN dba_cons_columns.constraint_name%TYPE;

  /******************************************************************************/
  /* Enable and validate a constraint
  /******************************************************************************/
  PROCEDURE enable_and_validate_constraint(owner_in           IN dba_constraints.owner%TYPE,
                                           table_name_in      IN dba_constraints.table_name%TYPE,
                                           constraint_name_in IN dba_constraints.constraint_name%TYPE);

  /******************************************************************************/
  /* Validate and enable all constraints in state NOT-VALIDATED of a table.
  /******************************************************************************/
  PROCEDURE validate_table_constraints(owner_in IN dba_constraints.owner%TYPE, table_name_in IN dba_constraints.table_name%TYPE);

  /*****************************************************************************
  * Disable Constraint
  *****************************************************************************/
  PROCEDURE disable_constraint(owner_in           IN dba_constraints.owner%TYPE,
                               table_name_in      IN dba_constraints.table_name%TYPE,
                               constraint_name_in IN dba_constraints.constraint_name%TYPE);

  /*****************************************************************************
  * Enable Constraint
  *****************************************************************************/
  PROCEDURE enable_constraint(owner_in           IN dba_constraints.owner%TYPE,
                              table_name_in      IN dba_constraints.table_name%TYPE,
                              constraint_name_in IN dba_constraints.constraint_name%TYPE);

  /*****************************************************************************
  * Drop a constraint
  *****************************************************************************/
  PROCEDURE drop_constraint(owner_in           IN dba_constraints.owner%TYPE,
                            table_name_in      IN dba_constraints.table_name%TYPE,
                            constraint_name_in IN dba_constraints.constraint_name%TYPE);

  /*******************************************************************************
  * Rename a constraint
  *******************************************************************************/
  PROCEDURE rename_constraint(owner_in               IN dba_constraints.owner%TYPE,
                              table_name_in          IN dba_constraints.table_name%TYPE,
                              old_constraint_name_in IN dba_constraints.constraint_name%TYPE,
                              new_constraint_name_in IN dba_constraints.constraint_name%TYPE);

  /*******************************************************************************
  * Rename an index
  *******************************************************************************/
  PROCEDURE rename_index(owner_in          IN dba_indexes.owner%TYPE,
                         old_index_name_in IN dba_indexes.index_name%TYPE,
                         new_index_name_in IN dba_indexes.index_name%TYPE);

  /*******************************************************************************
  * Return 1 if the column does exist in the table, else 0.
  *******************************************************************************/
  FUNCTION is_table_column(owner_in       IN dba_tab_columns.owner%TYPE,
                           table_name_in  IN dba_tab_columns.table_name%TYPE,
                           column_name_in IN dba_tab_columns.column_name%TYPE) RETURN NUMBER;

  /*******************************************************************************
  * Return 1 if the column does exist in the index, else 0.
  *******************************************************************************/
  FUNCTION is_index_column(owner_in       IN dba_ind_columns.index_owner%TYPE,
                           index_name_in  IN dba_ind_columns.index_name%TYPE,
                           column_name_in IN dba_ind_columns.column_name%TYPE) RETURN NUMBER;

  /******************************************************************************
  * Compile all invalid objects of an owner
  ******************************************************************************/
  PROCEDURE compile_invalid_objects(owner_in IN dba_objects.owner%TYPE);

  /******************************************************************************
  * Drop all triggers on a table
    ******************************************************************************/
  PROCEDURE drop_table_triggers(owner_in IN dba_triggers.table_owner%TYPE, table_name_in IN dba_triggers.table_name%TYPE);

  /******************************************************************************
  * Get the name of primary key of a table
  ******************************************************************************/
  FUNCTION get_table_primary_key_name(owner_in IN dba_constraints.owner%TYPE, table_name_in IN dba_constraints.table_name%TYPE)
    RETURN dba_constraints.constraint_name%TYPE;

  /******************************************************************************
  * Get PARTITIONING_TYPE and SUBPARTITIONING_TYPE from DBA_PART_TABLES
  ******************************************************************************/
  PROCEDURE get_table_partition_types(owner_in                 IN dba_part_tables.owner%TYPE,
                                      table_name_in            IN dba_part_tables.table_name%TYPE,
                                      partitioning_type_out    OUT dba_part_tables.partitioning_type%TYPE,
                                      subpartitioning_type_out OUT dba_part_tables.subpartitioning_type%TYPE);

  /******************************************************************************
  * Get PARTITIONING_TYPE and SUBPARTITIONING_TYPE from DBA_PART_INDEXES
  ******************************************************************************/
  PROCEDURE get_index_partition_types(owner_in                 IN dba_part_indexes.owner%TYPE,
                                      index_name_in            IN dba_part_indexes.index_name%TYPE,
                                      partitioning_type_out    OUT dba_part_indexes.partitioning_type%TYPE,
                                      subpartitioning_type_out OUT dba_part_indexes.subpartitioning_type%TYPE);

  /******************************************************************************
  * Rebuild an indexes (partitioned and non-partitioned) online.
  ******************************************************************************/
  PROCEDURE rebuild_index(index_owner_in    IN dba_indexes.owner%TYPE,
                          index_name_in     IN dba_indexes.index_name%TYPE,
                          partition_type_in IN VARCHAR2 DEFAULT NULL,
                          partition_name_in IN dba_ind_partitions.partition_name%TYPE DEFAULT NULL,
                          parallel_in       IN PLS_INTEGER DEFAULT 4);

  /******************************************************************************
  * Rebuild all unusable indexes (partitioned and non-partitioned) online.
  ******************************************************************************/
  PROCEDURE rebuild_unusable_indexes(table_owner_in IN dba_indexes.table_owner%TYPE DEFAULT NULL,
                                     table_name_in  IN dba_indexes.table_name%TYPE DEFAULT NULL,
                                     parallel_in    IN NUMBER DEFAULT NULL);

  /******************************************************************************
  * Alter index to UNUSABLE
  ******************************************************************************/
  PROCEDURE alter_index_unusable(index_owner_in IN dba_indexes.owner%TYPE, index_name_in IN dba_indexes.index_name%TYPE);

  /******************************************************************************
  * Alter all indexes of a table to UNUSABLE
  ******************************************************************************/
  PROCEDURE set_table_indexes_unusable(table_owner_in IN dba_indexes.table_owner%TYPE, table_name_in IN dba_indexes.table_name%TYPE);

  /*****************************************************************************
  * Truncate table
  *****************************************************************************/
  PROCEDURE truncate_table(owner_in IN dba_tables.owner%TYPE, table_name_in IN dba_tables.table_name%TYPE);

  /*****************************************************************************
  * Disable trigger
  *****************************************************************************/
  PROCEDURE disable_trigger(owner_in IN dba_triggers.owner%TYPE, trigger_name_in IN dba_triggers.trigger_name%TYPE);

  /*****************************************************************************
  * Enable trigger
  *****************************************************************************/
  PROCEDURE enable_trigger(owner_in IN dba_triggers.owner%TYPE, trigger_name_in IN dba_triggers.trigger_name%TYPE);
END object_admin;
/
CREATE OR REPLACE PACKAGE BODY object_admin IS
  /*****************************************************************************
  * Constants
  *****************************************************************************/
  gc_enterprise_edition PLS_INTEGER := sql_admin.is_enterprise_edition;

  /*****************************************************************************
  * Exception
  *****************************************************************************/
  e_maximum_key_length_exceeded EXCEPTION; -- ORA-01450: maximum key length (3215) exceeded
  PRAGMA EXCEPTION_INIT(e_maximum_key_length_exceeded, -01450);

  /*****************************************************************************
  * Return 1 if the object does exist, else 0.
  *****************************************************************************/
  FUNCTION is_object_existing(owner_in       IN dba_objects.owner%TYPE,
                              object_type_in IN dba_objects.object_type%TYPE,
                              object_name_in IN dba_objects.object_name%TYPE) RETURN NUMBER IS
    n_result NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO n_result
      FROM dba_objects o
     WHERE o.owner = owner_in
       AND o.object_type = object_type_in
       AND o.object_name = object_name_in;
  
    RETURN n_result;
  END is_object_existing;

  /*****************************************************************************
  * Drop an object
  *****************************************************************************/
  PROCEDURE drop_object(owner_in IN dba_objects.owner%TYPE, object_name_in IN dba_objects.object_name%TYPE, object_type_in IN dba_objects.object_type%TYPE) IS
  BEGIN
    sql_admin.execute_sql('DROP ' || object_type_in || ' "' || owner_in || '"."' || object_name_in || '"');
  END drop_object;

  /*****************************************************************************/
  /* Return 1 if the table is partitioned, else 0.
  /*****************************************************************************/
  FUNCTION is_table_partitioned(owner_in IN dba_tables.owner%TYPE, table_name_in IN dba_tables.table_name%TYPE) RETURN NUMBER IS
    n_result NUMBER;
  BEGIN
    SELECT decode(t.partitioned, 'YES', 1, 0)
      INTO n_result
      FROM dba_tables t
     WHERE t.owner = owner_in
       AND t.table_name = table_name_in;
  
    RETURN n_result;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN 0;
  END is_table_partitioned;

  /*****************************************************************************/
  /* Return 1 if the index is partitioned, else 0.
  /*****************************************************************************/
  FUNCTION is_index_partitioned(owner_in IN dba_indexes.owner%TYPE, index_name_in IN dba_indexes.table_name%TYPE) RETURN NUMBER IS
    n_result NUMBER;
  BEGIN
    SELECT decode(i.partitioned, 'YES', 1, 0)
      INTO n_result
      FROM dba_indexes i
     WHERE i.owner = owner_in
       AND i.index_name = index_name_in;
  
    RETURN n_result;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN 0;
  END is_index_partitioned;

  /*****************************************************************************/
  /* Return 1 if the object is partitioned, else 0.
  /*****************************************************************************/
  FUNCTION is_object_partitioned(owner_in       IN dba_objects.owner%TYPE,
                                 object_name_in IN dba_objects.object_name%TYPE,
                                 object_type_in IN dba_objects.object_type%TYPE) RETURN NUMBER IS
  BEGIN
    IF object_type_in = 'TABLE' THEN
      RETURN is_table_partitioned(owner_in => owner_in, table_name_in => object_name_in);
    ELSIF object_type_in = 'INDEX' THEN
      RETURN is_index_partitioned(owner_in => owner_in, index_name_in => object_name_in);
    ELSE
      RETURN 0;
    END IF;
  END is_object_partitioned;

  /*****************************************************************************/
  /* Return 1 if the object partition key is the provided one, else 0.
  /*****************************************************************************/
  FUNCTION is_object_partition_key(owner_in         IN dba_part_key_columns.owner%TYPE,
                                   object_name_in   IN dba_part_key_columns.name%TYPE,
                                   object_type_in   IN dba_part_key_columns.object_type%TYPE,
                                   partition_key_in IN dba_part_key_columns.column_name%TYPE) RETURN NUMBER IS
    n_result NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO n_result
      FROM dba_part_key_columns dpkc
     WHERE dpkc.owner = owner_in
       AND dpkc.name = object_name_in
       AND dpkc.object_type = object_type_in
       AND dpkc.column_name = partition_key_in;
  
    RETURN n_result;
  END is_object_partition_key;

  /*****************************************************************************/
  /* Return 1 if the object subpartition key is the provided one, else 0.
  /*****************************************************************************/
  FUNCTION is_object_subpartition_key(owner_in            IN dba_subpart_key_columns.owner%TYPE,
                                      object_name_in      IN dba_subpart_key_columns.name%TYPE,
                                      object_type_in      IN dba_subpart_key_columns.object_type%TYPE,
                                      subpartition_key_in IN dba_subpart_key_columns.column_name%TYPE) RETURN NUMBER IS
    n_result NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO n_result
      FROM dba_subpart_key_columns dskc
     WHERE dskc.owner = owner_in
       AND dskc.name = object_name_in
       AND dskc.object_type = object_type_in
       AND dskc.column_name = subpartition_key_in;
  
    RETURN n_result;
  END is_object_subpartition_key;

  /*****************************************************************************/
  /* Return the value of DBA_TABLES.DEGREE
  /*****************************************************************************/
  FUNCTION get_table_degree(owner_in IN dba_tables.owner%TYPE, table_name_in IN dba_tables.table_name%TYPE) RETURN dba_tables.degree%TYPE IS
    n_result dba_tables.degree%TYPE;
  BEGIN
    SELECT t.degree
      INTO n_result
      FROM dba_tables t
     WHERE t.owner = owner_in
       AND t.table_name = table_name_in;
  
    RETURN n_result;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_table_degree;

  /*****************************************************************************/
  /* Return the value of DBA_INDEXES.DEGREE
  /*****************************************************************************/
  FUNCTION get_index_degree(owner_in IN dba_indexes.owner%TYPE, index_name_in IN dba_indexes.index_name%TYPE) RETURN dba_indexes.degree%TYPE IS
    n_result dba_indexes.degree%TYPE;
  BEGIN
    SELECT i.degree
      INTO n_result
      FROM dba_indexes i
     WHERE i.owner = owner_in
       AND i.index_name = index_name_in;
  
    RETURN n_result;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_index_degree;

  /*****************************************************************************/
  /* Return the name of the foreign key on this column.
  /*
  /* Hint: Only foreign keys on a single column are supported
  /*****************************************************************************/
  FUNCTION get_foreign_key_name_on_column(owner_in       IN dba_cons_columns.owner%TYPE,
                                          table_name_in  IN dba_cons_columns.table_name%TYPE,
                                          column_name_in IN dba_cons_columns.column_name%TYPE) RETURN dba_cons_columns.constraint_name%TYPE IS
    v_result dba_cons_columns.constraint_name%TYPE;
  BEGIN
    SELECT dcc.constraint_name
      INTO v_result
      FROM dba_cons_columns dcc
      JOIN dba_constraints dc
        ON (dc.owner = dcc.owner AND dc.table_name = dcc.table_name AND dc.constraint_name = dcc.constraint_name)
     WHERE dcc.owner = owner_in
       AND dcc.table_name = table_name_in
       AND dcc.column_name = column_name_in
       AND dc.constraint_type = 'R';
  
    RETURN v_result;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE;
  END get_foreign_key_name_on_column;

  /*****************************************************************************/
  /* Enable and validate a constraint
  /*****************************************************************************/
  PROCEDURE enable_and_validate_constraint(owner_in           IN dba_constraints.owner%TYPE,
                                           table_name_in      IN dba_constraints.table_name%TYPE,
                                           constraint_name_in IN dba_constraints.constraint_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql(sql_in => 'ALTER TABLE "' || owner_in || '"."' || table_name_in || '" MODIFY CONSTRAINT "' || constraint_name_in ||
                                    '" ENABLE VALIDATE');
  END enable_and_validate_constraint;

  /*****************************************************************************/
  /* Validate and enable all constraints in state NOT-VALIDATED of a table.
  /*****************************************************************************/
  PROCEDURE validate_table_constraints(owner_in IN dba_constraints.owner%TYPE, table_name_in IN dba_constraints.table_name%TYPE) IS
  BEGIN
    FOR i IN (SELECT dc.owner, dc.table_name, dc.constraint_name
                FROM dba_constraints dc
               WHERE dc.table_name NOT LIKE 'BIN%'
                 AND dc.constraint_name NOT LIKE 'BIN%'
                 AND dc.owner = owner_in
                 AND dc.table_name = table_name_in
                 AND (dc.validated != 'VALIDATED' OR dc.status != 'ENABLED')) LOOP
      enable_and_validate_constraint(owner_in => i.owner, table_name_in => i.table_name, constraint_name_in => i.constraint_name);
    END LOOP;
  END validate_table_constraints;

  /*****************************************************************************
  * Disable Constraint
  *****************************************************************************/
  PROCEDURE disable_constraint(owner_in           IN dba_constraints.owner%TYPE,
                               table_name_in      IN dba_constraints.table_name%TYPE,
                               constraint_name_in IN dba_constraints.constraint_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql(sql_in => 'ALTER TABLE "' || owner_in || '"."' || table_name_in || '" DISABLE CONSTRAINT "' || constraint_name_in || '"');
  END disable_constraint;

  /*****************************************************************************
  * Enable and validate Constraint
  *****************************************************************************/
  PROCEDURE enable_constraint(owner_in           IN dba_constraints.owner%TYPE,
                              table_name_in      IN dba_constraints.table_name%TYPE,
                              constraint_name_in IN dba_constraints.constraint_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql(sql_in => 'ALTER TABLE "' || owner_in || '"."' || table_name_in || '" ENABLE VALIDATE CONSTRAINT "' || constraint_name_in || '"');
  END enable_constraint;

  /*****************************************************************************
  * Drop a constraint
  *****************************************************************************/
  PROCEDURE drop_constraint(owner_in           IN dba_constraints.owner%TYPE,
                            table_name_in      IN dba_constraints.table_name%TYPE,
                            constraint_name_in IN dba_constraints.constraint_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql(sql_in => 'ALTER TABLE "' || owner_in || '"."' || table_name_in || '" DROP CONSTRAINT "' || constraint_name_in || '"');
  END drop_constraint;

  /*****************************************************************************
  * Rename a constraint
  *****************************************************************************/
  PROCEDURE rename_constraint(owner_in               IN dba_constraints.owner%TYPE,
                              table_name_in          IN dba_constraints.table_name%TYPE,
                              old_constraint_name_in IN dba_constraints.constraint_name%TYPE,
                              new_constraint_name_in IN dba_constraints.constraint_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql(sql_in => 'ALTER TABLE "' || owner_in || '"."' || table_name_in || '" RENAME CONSTRAINT "' || old_constraint_name_in || '" TO "' ||
                                    new_constraint_name_in || '"');
  END rename_constraint;

  /*****************************************************************************
  * Rename an index
  *****************************************************************************/
  PROCEDURE rename_index(owner_in          IN dba_indexes.owner%TYPE,
                         old_index_name_in IN dba_indexes.index_name%TYPE,
                         new_index_name_in IN dba_indexes.index_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql(sql_in => 'ALTER INDEX "' || owner_in || '"."' || old_index_name_in || '" RENAME TO "' || new_index_name_in || '"');
  END rename_index;

  /*****************************************************************************
  * Return 1 if the column does exist in the table, else 0.
  *****************************************************************************/
  FUNCTION is_table_column(owner_in       IN dba_tab_columns.owner%TYPE,
                           table_name_in  IN dba_tab_columns.table_name%TYPE,
                           column_name_in IN dba_tab_columns.column_name%TYPE) RETURN NUMBER IS
    n_result NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO n_result
      FROM dba_tab_columns
     WHERE owner = owner_in
       AND table_name = table_name_in
       AND column_name = column_name_in;
  
    RETURN n_result;
  END is_table_column;

  /*****************************************************************************
  * Return 1 if the column does exist in the index, else 0.
  *****************************************************************************/
  FUNCTION is_index_column(owner_in       IN dba_ind_columns.index_owner%TYPE,
                           index_name_in  IN dba_ind_columns.index_name%TYPE,
                           column_name_in IN dba_ind_columns.column_name%TYPE) RETURN NUMBER IS
    n_result NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO n_result
      FROM dba_ind_columns
     WHERE index_owner = owner_in
       AND index_name = index_name_in
       AND column_name = column_name_in;
  
    RETURN n_result;
  END is_index_column;

  /*****************************************************************************
  * Compile all invalid objects of an owner
  *****************************************************************************/
  PROCEDURE compile_invalid_objects(owner_in IN dba_objects.owner%TYPE) IS
  BEGIN
    FOR obj IN (SELECT object_type, owner, object_name
                  FROM dba_objects
                 WHERE owner = owner_in
                   AND status != 'VALID'
                   AND object_name NOT LIKE 'TMP$$%') LOOP
      BEGIN
        IF obj.object_type = 'PACKAGE BODY' THEN
          sql_admin.execute_sql(sql_in => 'ALTER PACKAGE "' || obj.owner || '"."' || obj.object_name || '" COMPILE BODY');
        ELSE
          sql_admin.execute_sql(sql_in => 'ALTER ' || obj.object_type || ' "' || obj.owner || '"."' || obj.object_name || '" COMPILE');
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          IF SQLCODE = -24344 THEN
            NULL;
          END IF;
      END;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END compile_invalid_objects;

  /*****************************************************************************
  * Drop all triggers on a table
  *****************************************************************************/
  PROCEDURE drop_table_triggers(owner_in IN dba_triggers.table_owner%TYPE, table_name_in IN dba_triggers.table_name%TYPE) IS
  BEGIN
    FOR i IN (SELECT trigger_name
                FROM dba_triggers
               WHERE table_owner = owner_in
                 AND table_name = table_name_in) LOOP
      drop_object(owner_in => owner_in, object_name_in => i.trigger_name, object_type_in => 'TRIGGER');
    END LOOP;
  END drop_table_triggers;

  /*****************************************************************************
  * Get the name of primary key of a table
  *****************************************************************************/
  FUNCTION get_table_primary_key_name(owner_in IN dba_constraints.owner%TYPE, table_name_in IN dba_constraints.table_name%TYPE)
    RETURN dba_constraints.constraint_name%TYPE IS
    v_result dba_constraints.constraint_name%TYPE;
  BEGIN
    SELECT c.constraint_name
      INTO v_result
      FROM dba_constraints c
     WHERE c.owner = owner_in
       AND c.table_name = table_name_in
       AND c.constraint_type = 'P';
  
    RETURN v_result;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_table_primary_key_name;

  /*****************************************************************************
  * Get PARTITIONING_TYPE and SUBPARTITIONING_TYPE from DBA_TABLE_PARTS
  *****************************************************************************/
  PROCEDURE get_table_partition_types(owner_in                 IN dba_part_tables.owner%TYPE,
                                      table_name_in            IN dba_part_tables.table_name%TYPE,
                                      partitioning_type_out    OUT dba_part_tables.partitioning_type%TYPE,
                                      subpartitioning_type_out OUT dba_part_tables.subpartitioning_type%TYPE) IS
  BEGIN
    SELECT decode(p.partitioning_type, 'NONE', NULL, p.partitioning_type), decode(p.subpartitioning_type, 'NONE', NULL, p.subpartitioning_type)
      INTO partitioning_type_out, subpartitioning_type_out
      FROM dba_part_tables p
     WHERE p.owner = owner_in
       AND p.table_name = table_name_in;
  EXCEPTION
    WHEN no_data_found THEN
      partitioning_type_out    := NULL;
      subpartitioning_type_out := NULL;
  END get_table_partition_types;

  /*****************************************************************************
  * Get PARTITIONING_TYPE and SUBPARTITIONING_TYPE from DBA_PART_INDEXES
  *****************************************************************************/
  PROCEDURE get_index_partition_types(owner_in                 IN dba_part_indexes.owner%TYPE,
                                      index_name_in            IN dba_part_indexes.index_name%TYPE,
                                      partitioning_type_out    OUT dba_part_indexes.partitioning_type%TYPE,
                                      subpartitioning_type_out OUT dba_part_indexes.subpartitioning_type%TYPE) IS
  BEGIN
    SELECT decode(p.partitioning_type, 'NONE', NULL, p.partitioning_type), decode(p.subpartitioning_type, 'NONE', NULL, p.subpartitioning_type)
      INTO partitioning_type_out, subpartitioning_type_out
      FROM dba_part_indexes p
     WHERE p.owner = owner_in
       AND p.table_name = index_name_in;
  EXCEPTION
    WHEN no_data_found THEN
      partitioning_type_out    := NULL;
      subpartitioning_type_out := NULL;
  END get_index_partition_types;

  /*****************************************************************************
  * Rebuild an indexes (partitioned and non-partitioned) online.
  *****************************************************************************/
  PROCEDURE rebuild_index(index_owner_in    IN dba_indexes.owner%TYPE,
                          index_name_in     IN dba_indexes.index_name%TYPE,
                          partition_type_in IN VARCHAR2 DEFAULT NULL,
                          partition_name_in IN dba_ind_partitions.partition_name%TYPE DEFAULT NULL,
                          parallel_in       IN PLS_INTEGER DEFAULT 4) IS
    l_degree PLS_INTEGER := nvl(get_index_degree(owner_in => index_owner_in, index_name_in => index_name_in), 1);
    v_sql    VARCHAR2(4000 CHAR);
  BEGIN
    v_sql := 'ALTER INDEX "' || index_owner_in || '"."' || index_name_in || '" REBUILD';
    -- If Instance is running Oracle EE add ONLINE and PARALLEL to SQL
    IF gc_enterprise_edition = 1 THEN
      -- If partition type and partition name are provided, add them to the SQL
      IF (partition_type_in IS NOT NULL AND partition_name_in IS NOT NULL) THEN
        v_sql := v_sql || ' ' || partition_type_in || ' ' || partition_name_in;
      END IF;
      -- Add PARALLEL clause
      v_sql := v_sql || ' PARALLEL ' || greatest(l_degree, parallel_in);
      -- Add ONLINE clause
      v_sql := v_sql || ' ONLINE';
    END IF;
    -- For indexes on VARCHAR2 columns sometimes ORA-01450 is raise. If this is the case, remove the ONLINE
    -- keyword and try rebuild again
    BEGIN
      sql_admin.execute_sql(sql_in => v_sql);
    EXCEPTION
      WHEN e_maximum_key_length_exceeded THEN
        v_sql := REPLACE(v_sql, 'ONLINE');
        sql_admin.execute_sql(sql_in => v_sql);
      WHEN OTHERS THEN
        RAISE;
    END;
    sql_admin.execute_sql(sql_in => 'ALTER INDEX "' || index_owner_in || '"."' || index_name_in || '" PARALLEL ' || l_degree);
  END rebuild_index;

  /*****************************************************************************
  * Rebuild all indexes (partitioned and non-partitioned) online.
  * TABLE_OWNER_IN can be used to specify the table. Otherwise all not-valid
  * indexes will be rebuilded
  *****************************************************************************/
  PROCEDURE rebuild_unusable_indexes(table_owner_in IN dba_indexes.table_owner%TYPE DEFAULT NULL,
                                     table_name_in  IN dba_indexes.table_name%TYPE DEFAULT NULL,
                                     parallel_in    IN NUMBER DEFAULT NULL) IS
  BEGIN
    FOR i IN (SELECT t.owner AS index_owner,
                     t.index_name,
                     t.partition_type,
                     t.partition_name,
                     nvl2(parallel_in,
                          parallel_in,
                          (SELECT i.degree
                             FROM dba_indexes i
                            WHERE i.owner = t.owner
                              AND i.index_name = t.index_name)) AS degree
                FROM (SELECT ix.owner, ix.index_name, NULL AS partition_type, NULL AS partition_name
                        FROM dba_indexes ix
                       WHERE ix.status NOT IN ('N/A', 'VALID')
                         AND nvl2(table_owner_in, ix.table_owner, -1) = nvl2(table_owner_in, ix.table_owner, -1)
                         AND nvl2(table_name_in, ix.table_name, -1) = nvl2(table_name_in, ix.table_name, -1)
                      UNION ALL
                      SELECT ix.index_owner AS owner, ix.index_name, 'PARTITION' AS partition_type, ix.partition_name partition_name
                        FROM dba_ind_partitions ix
                       WHERE ix.status NOT IN ('N/A', 'USABLE')
                      UNION ALL
                      SELECT ix.index_owner AS owner, ix.index_name, 'SUBPARTITION' AS partition_type, ix.subpartition_name AS partition_name
                        FROM dba_ind_subpartitions ix
                       WHERE ix.status NOT IN ('N/A', 'USABLE')) t) LOOP
      rebuild_index(index_owner_in    => i.index_owner,
                    index_name_in     => i.index_name,
                    partition_type_in => i.partition_type,
                    partition_name_in => i.partition_name,
                    parallel_in       => i.degree);
    END LOOP;
  END rebuild_unusable_indexes;

  /*****************************************************************************
  * Alter index to UNUSABLE
  *****************************************************************************/
  PROCEDURE alter_index_unusable(index_owner_in IN dba_indexes.owner%TYPE, index_name_in IN dba_indexes.index_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql('ALTER INDEX "' || index_owner_in || '"."' || index_name_in || '" UNUSABLE');
  END alter_index_unusable;

  /*****************************************************************************
  * Alter all indexes of a table to UNUSABLE which are not UNIQUE
  *****************************************************************************/
  PROCEDURE set_table_indexes_unusable(table_owner_in IN dba_indexes.table_owner%TYPE, table_name_in IN dba_indexes.table_name%TYPE) IS
  BEGIN
    FOR i IN (SELECT i.owner, i.index_name
                FROM dba_indexes i
               WHERE i.table_owner = table_owner_in
                 AND i.table_name = table_name_in
                 AND i.uniqueness != 'UNIQUE') LOOP
      alter_index_unusable(index_owner_in => i.owner, index_name_in => i.index_name);
    END LOOP;
  END set_table_indexes_unusable;

  /*****************************************************************************
  * Truncate table
  *****************************************************************************/
  PROCEDURE truncate_table(owner_in IN dba_tables.owner%TYPE, table_name_in IN dba_tables.table_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql('TRUNCATE TABLE "' || owner_in || '"."' || table_name_in || '" DROP ALL STORAGE');
  END truncate_table;

  /*****************************************************************************
  * Initialize
  *****************************************************************************/
  PROCEDURE initialize IS
  BEGIN
    module_admin.load_and_set_config(module_name_in => $$PLSQL_UNIT);
  END initialize;

  /*****************************************************************************
  * Disable trigger
  *****************************************************************************/
  PROCEDURE disable_trigger(owner_in IN dba_triggers.owner%TYPE, trigger_name_in IN dba_triggers.trigger_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql('ALTER TRIGGER "' || owner_in || '"."' || trigger_name_in || '" DISABLE');
  END disable_trigger;

  /*****************************************************************************
  * Enable trigger
  *****************************************************************************/
  PROCEDURE enable_trigger(owner_in IN dba_triggers.owner%TYPE, trigger_name_in IN dba_triggers.trigger_name%TYPE) IS
  BEGIN
    sql_admin.execute_sql('ALTER TRIGGER "' || owner_in || '"."' || trigger_name_in || '" ENABLE');
  END enable_trigger;

BEGIN
  initialize;
END object_admin;
/

CREATE OR REPLACE FUNCTION add_index(
    c_source_table_name VARCHAR2,
    c_new_table_name    VARCHAR2,
    c_suffix            VARCHAR2,
    c_owner_name        VARCHAR2)
  RETURN NUMBER
IS
  c_check_tbl_exist_query CLOB;
  c_count_tbl      NUMBER;
  c_new_index_name VARCHAR2(1000);
  c_max_num_tbl    NUMBER :=2;
  c_create_index_query CLOB;
BEGIN
  /***  Validate table exists  ***/
  c_check_tbl_exist_query := 'select count(1) from USER_OBJECTS WHERE OBJECT_TYPE = ''TABLE'' AND OBJECT_NAME IN (''' || c_source_table_name || ''',''' || c_new_table_name ||''')';
  EXECUTE IMMEDIATE c_check_tbl_exist_query INTO c_count_tbl;



  IF c_count_tbl = c_max_num_tbl THEN
    /***  List Indexs  ***/
    FOR i IN
    (SELECT INDEX_NAME
    FROM USER_INDEXES
    WHERE TABLE_NAME = c_source_table_name
    AND TABLE_OWNER  = c_owner_name
    )
    LOOP

      c_new_index_name := REPLACE(i.INDEX_NAME


      /***  Generate a create index query  ***/
      SELECT DBMS_METADATA.GET_DDL('INDEX', i.INDEX_NAME, c_owner_name)
      INTO c_create_index_query
      FROM dual;
      c_create_index_query := REPLACE(c_create_index_query, c_source_table_name, c_new_table_name);
      c_create_index_query := REPLACE(c_create_index_query, i.INDEX_NAME, i.INDEX_NAME || '_' || c_suffix);
      c_create_index_query := REPLACE(c_create_index_query, ';', '');

      DBMS_OUTPUT.PUT_LINE(c_create_index_query);
      DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------');
      EXECUTE Immediate c_create_index_query;
      COMMIT;

    END LOOP;
  ELSE
    RETURN 0;
  END IF;

RETURN 1;

END;
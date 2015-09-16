CREATE OR REPLACE FUNCTION add_comments(
    c_source_table_name VARCHAR2,
    c_new_table_name    VARCHAR2,
    c_owner_name        VARCHAR2)
  RETURN NUMBER
IS
  c_check_tbl_exist_query CLOB;
  c_count_tbl NUMBER;
BEGIN
  /***  Validate table exists  ***/
  c_check_tbl_exist_query := 'select count(1) from USER_OBJECTS WHERE OBJECT_TYPE = ''TABLE'' AND OBJECT_NAME IN (''' || c_source_table_name || ''',''' || c_new_table_name ||''')';
  DBMS_OUTPUT.put_line(c_check_tbl_exist_query);
  EXECUTE IMMEDIATE c_check_tbl_exist_query INTO c_count_tbl;



  /***  Add Comments  ***/
  IF c_count_tbl = 2 THEN
    FOR i IN
    (SELECT 'COMMENT ON COLUMN "'
      || c_owner_name
      ||'"."'
      || c_new_table_name
      ||'"."'
      || COLUMN_NAME
      || '" IS '''
      || COMMENTS
      || '''' query
    FROM user_col_comments
    WHERE TABLE_NAME = 'EMPLY_PROFL'
    AND COMMENTS    IS NOT NULL
    )
    LOOP
      EXECUTE IMMEDIATE i.query;
      COMMIT;
    END LOOP;
  ELSE
    RETURN 0;
  END IF;

RETURN 1;
END;
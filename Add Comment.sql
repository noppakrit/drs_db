CREATE OR REPLACE FUNCTION add_comments(
    c_source_table_name VARCHAR2,
    c_new_table_name    VARCHAR2,
    c_owner_name        VARCHAR2)
  RETURN NUMBER
IS
BEGIN

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

RETURN 1;
END;
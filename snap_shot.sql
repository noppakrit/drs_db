CREATE OR REPLACE FUNCTION duplicate_table(
    c_source_tbl_name IN VARCHAR2,
    c_new_tbl_name    IN VARCHAR2,
    c_schema_name     IN VARCHAR2)
  RETURN NUMBER
IS
  c_check_tbl_exist_query CLOB;
  c_count_tbl NUMBER := 0;
  c_drop_tbl_query CLOB;
  c_create_tbl_query CLOB;
  c_create_index_query CLOB;
BEGIN
  /***  Check table exist  ***/
  c_check_tbl_exist_query := 'select count(1) from USER_OBJECTS WHERE OBJECT_TYPE = ''TABLE'' AND OBJECT_NAME   = ''' || c_new_tbl_name || '''';
  EXECUTE IMMEDIATE c_check_tbl_exist_query INTO c_count_tbl;
  
  
  
  /***  Generate a drop table query  ***/
  IF c_count_tbl      = 1 THEN
    c_drop_tbl_query := 'Drop table ' || c_new_tbl_name || ' PURGE';
    EXECUTE IMMEDIATE c_drop_tbl_query;
    COMMIT;
  END IF;


/***  Generate a create table query  ***/
SELECT DBMS_METADATA.GET_DDL('TABLE', c_source_tbl_name, c_schema_name)
INTO c_create_tbl_query
FROM dual;
c_create_tbl_query := REPLACE(c_create_tbl_query, c_source_tbl_name, c_new_tbl_name);
c_create_tbl_query := REPLACE(c_create_tbl_query, ';', '');



/***  Execute a create table query  ***/
EXECUTE IMMEDIATE c_create_tbl_query;
COMMIT;
--  DBMS_OUTPUT.PUT_LINE('Source Table Name: ' || c_source_tbl_name);
--  DBMS_OUTPUT.PUT_LINE('New Table Name: ' || c_new_tbl_name);
--  DBMS_OUTPUT.PUT_LINE('Schema Name: ' || c_schema_name);
RETURN 1;
END;
CREATE OR REPLACE PROCEDURE duplicate_table(
    c_source_tbl_name IN VARCHAR2,
    c_new_tbl_name    IN VARCHAR2,
    c_schema_name     IN VARCHAR2)
IS
  c_create_tbl_query CLOB;
  c_create_index_query CLOB;
BEGIN
  
  /***  Generate a create table query  ***/
  SELECT DBMS_METADATA.GET_DDL('TABLE', c_source_tbl_name, c_schema_name)
  INTO c_sql
  FROM dual;
  c_create_tbl_query := REPLACE(c_sql,c_source_tbl_name,c_new_tbl_name);
  c_create_tbl_query := REPLACE(c_sql,';','');
  
  /***  Execute a create table query  ***/
  EXECUTE IMMEDIATE c_create_tbl_query;
  
  
  
  DBMS_OUTPUT.PUT_LINE('Source Table Name: ' || c_source_tbl_name);
  DBMS_OUTPUT.PUT_LINE('New Table Name: ' || c_new_tbl_name);
  DBMS_OUTPUT.PUT_LINE('Schema Name: ' || c_schema_name);
  DBMS_OUTPUT.PUT_LINE(c_sql);
END;
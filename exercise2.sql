CREATE USER JOHN;

ALTER ROLE john WITH PASSWORD 'secret';

ALTER ROLE john CREATEDB;
GRANT CONNECT ON DATABASE testdb to john;

CREATE SCHEMA sales;

SET search_path to sales;

GRANT USAGE ON SCHEMA sales to john;

CREATE TABLE sales.customers();

GRANT SELECT, INSERT ON sales.customers TO john;

CREATE TABLE sales.orders();


GRANT USAGE ON table sales.orders to john;

GRANT SELECT, INSERT ON sales.orders TO john;

CREATE ROLE sales_manager;

GRANT CREATE ON SCHEMA sales to sales_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON sales.customers TO sales_manager;

REVOKE SELECT ON sales.customers from john;



select * from information_schema.role_table_grants where grantee = 'john';

CREATE TABLE IF NOT EXISTS products (
id int,
name VARCHAR(50),
description TEXT,
category_id int,
branch_id int
);


CREATE TABLE IF NOT EXISTS categories (
id int,
name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS branches (
id int,
name VARCHAR(50)
);


CREATE SEQUENCE categories_id_seq
 as integer START 1 OWNED by products.category_id;

CREATE SEQUENCE branches_id_seq
 as integer START 1 OWNED by products.branch_id;

ALTER TABLE products
 ALTER COLUMN category_id SET DEFAULT nextval('categories_id_seq');

ALTER TABLE products
 ALTER COLUMN branch_id SET DEFAULT nextval('branches_id_seq');

ALTER TABLE products
 ADD CONSTRAINT pk_products
   PRIMARY KEY (id);


ALTER TABLE categories
 ADD CONSTRAINT pk_categories
   PRIMARY KEY (id);

ALTER TABLE branches
 ADD CONSTRAINT pk_branches
   PRIMARY KEY (id);


ALTER TABLE products
ADD CONSTRAINT fk_pk_categories
FOREIGN KEY (category_id)
REFERENCES categories (id);

ALTER TABLE products
ADD CONSTRAINT fk_pk_branches
FOREIGN KEY (branch_id)
REFERENCES branches (id);


INSERT INTO categories (id,name) VALUES (1,'fresh');
INSERT INTO categories (id,name) VALUES (2,'frozen');

INSERT INTO branches (id,name) VALUES (1,'SM');
INSERT INTO branches (id,name) VALUES (2,'SNR');


INSERT INTO products (id, name, description, category_id, branch_id ) values('1','SM_PRODUCTS','training exercise2',1,1);




/*product table */
DROP TABLE IF EXISTS products;
CREATE TABLE IF NOT EXISTS products (
	id int,
	name VARCHAR(50),
	description TEXT,
	category_id int NOT NULL,
	branch_id int NOT NULL
	);


	CREATE SEQUENCE products_id_seq
	 as integer START 1 OWNED by products.id;

	ALTER TABLE products
	 ALTER COLUMN id SET DEFAULT nextval('products_id_seq');

	ALTER TABLE products
	 ADD CONSTRAINT pk_products
	   PRIMARY KEY (id);


	/*categories table */
DROP TABLE IF EXISTS categories;
CREATE TABLE IF NOT EXISTS categories (
	id int,
	name VARCHAR(50)
	);

	CREATE SEQUENCE categories_id_seq
	 as integer START 1 OWNED by categories.id;

	ALTER TABLE categories
	 ALTER COLUMN id SET DEFAULT nextval('categories_id_seq');

	ALTER TABLE categories
	 ADD CONSTRAINT pk_categories
	   PRIMARY KEY (id);


	/*branches  table */
DROP TABLE IF EXISTS branches;
CREATE TABLE IF NOT EXISTS branches (
	id int,
	name VARCHAR(50)
	);


	CREATE SEQUENCE branches_id_seq
	 as integer START 1 OWNED by branches.id;

	ALTER TABLE branches
	 ALTER COLUMN id SET DEFAULT nextval('branches_id_seq');


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



	INSERT INTO categories (name) VALUES ('fresh');
	INSERT INTO categories (name) VALUES ('frozen');

	INSERT INTO branches (name) VALUES ('SM');
	INSERT INTO branches (name) VALUES ('SNR');


	INSERT INTO products (name, description, category_id, branch_id ) values('SM_PRODUCTS','training exercise2',1,1);

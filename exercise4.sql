/* CREATE TABLE customers */
DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE customers (
		id SERIAL PRIMARY KEY,
			first_name VARCHAR(50) NOT NULL,
				last_name VARCHAR(50) NOT NULL
			);


			/* CREATE TABLE accounts */
DROP TABLE IF EXISTS accounts CASCADE;
CREATE TABLE accounts (
		id SERIAL PRIMARY KEY,
			balance NUMERIC NOT NULL DEFAULT 0.0,
			maintaining_balance NUMERIC NOT NULL DEFAULT 500.00,
			customer_id INT NOT NULL,
					CONSTRAINT fk_customer_id
							FOREIGN KEY (customer_id)
										REFERENCES customers(id)
									);

									/* CREATE INSERT DATA */
INSERT INTO customers (first_name, last_name) VALUES ('JEFF', 'SEGOVIA');
INSERT INTO accounts (customer_id) VALUES (1);

/* VERIFY DATA */
select * from customers;
select * from accounts;


/* CREATE FUNCTION to get_total_balance(customer_id) return numeric*/
DROP FUNCTION IF EXISTS get_total_balance;
CREATE OR REPLACE FUNCTION get_total_balance (
	customer_id INT
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
	total_balance NUMERIC := 0.0;
BEGIN
	SELECT SUM(balance) INTO total_balance FROM accounts WHERE customers_id = customer_id;
	RETURN total_balance;
END;$$;


SELECT * FROM accounts;


/* CHECK A FUNCTION deposit(id, amount) return BOOLEAN */
DROP FUNCTION IF EXISTS deposit;
CREATE OR REPLACE FUNCTION deposit (
	_id INT,
	_amount NUMERIC
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	results BOOLEAN := TRUE;
	current_balance NUMERIC;
	new_balance NUMERIC;
BEGIN
	SELECT balance INTO current_balance FROM accounts WHERE accounts.id = _id;
	new_balance := current_balance + _amount;
	UPDATE accounts SET balance = new_balance WHERE accounts.id = _id;
RETURN results;
END;$$;

/* CHECK ACCOUNT  */

SELECT deposit(1, 800.00);

SELECT * FROM accounts;


/* CHECK A FUNCTION withdraw(id, amount) return BOOLEAN */


DROP FUNCTION IF EXISTS withdraw;
CREATE OR REPLACE FUNCTION withdraw (
	_id INT,
	_amount NUMERIC
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	result BOOLEAN := TRUE;
	current_balance NUMERIC;
	new_balance NUMERIC;
	_maintaining_balance NUMERIC;
BEGIN
	SELECT balance INTO current_balance FROM accounts WHERE accounts.id = _id;
	SELECT maintaining_balance INTO _maintaining_balance FROM accounts WHERE accounts.id = _id;
	new_balance := current_balance - _amount;
	IF new_balance < _maintaining_balance THEN
	result := FALSE;
	RAISE NOTICE 'Account % is below maintaining balance % for the withdrawal of amount %', _id, current_balance, _amount;
	ELSE
	UPDATE accounts SET balance = new_balance WHERE accounts.id = _id;
	END IF;
RETURN result;	
END;$$;

/* CHECK ACCOUNT  */

SELECT withdraw(1, 1500.00);

SELECT * FROM accounts;

SELECT withdraw(1, 150.00);

SELECT * FROM accounts;


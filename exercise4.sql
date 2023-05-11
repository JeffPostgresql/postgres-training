/* CREATE TABLE customers */
SELECT '====DROP and CREATE TABLE CUSTOMERS==========';
DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE customers (
		id SERIAL PRIMARY KEY,
			first_name VARCHAR(50) NOT NULL,
				last_name VARCHAR(50) NOT NULL
			);


			/* CREATE TABLE accounts */

SELECT '=======DROP AND CREATE TABLE ACCOUNTS=========';
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
SELECT '=======DROP AND CREATE ACCOUNT_TRANSACTION=========';
DROP TABLE IF EXISTS account_transactions CASCADE;
CREATE TABLE IF NOT EXISTS account_transactions (
	  id SERIAL PRIMARY KEY,
	  amount NUMERIC NOT NULL,
	  transaction_type VARCHAR(1) NOT NULL,
	  account_id INT NOT NULL,
	  CONSTRAINT fk_account_id
	    FOREIGN KEY (account_id)
		REFERENCES accounts(id),
	beginning_balance DECIMAL NOT NULL,
	ending_balance DECIMAL NOT NULL

	);

	ALTER TABLE account_transactions
	  ADD CONSTRAINT check_transaction_type
	  CHECK (transaction_type IN ('W', 'D'));

/* CREATE INSERT DATA */
SELECT '=======INSERT DATA=========';
INSERT INTO customers (first_name, last_name) VALUES ('JEFF', 'SEGOVIA');
INSERT INTO accounts (customer_id) VALUES (1);

/* VERIFY DATA */
SELECT '=======VERIFY DATA=========';
select * from customers;
select * from accounts;


/* CREATE FUNCTION to get_total_balance(customer_id) return numeric*/
SELECT '=======CREATE FUNCTION GET_TOTAL_BALANCE=========';
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

SELECT '=======CREATE FUNTION DEPOSIT=========';

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


SELECT deposit(1, 1000.00);
SELECT '=======DEPOSIT 1000=========';
SELECT * FROM accounts;


/* CHECK A FUNCTION withdraw(id, amount) return BOOLEAN */

SELECT '=======CREATE FUNCTION WITHDRAW=========';
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
	RAISE NOTICE 'Account % is below % maintaining balance for the withdrawal amount of % from %', _id , _maintaining_balance,  _amount, current_balance;
	ELSE
	UPDATE accounts SET balance = new_balance WHERE accounts.id = _id;
	END IF;
RETURN result;	
END;$$;


SELECT '=======CREATE FUNTION P_WITHDRAW=========';
DROP PROCEDURE IF EXISTS p_withdraw;
CREATE OR REPLACE PROCEDURE p_withdraw(
	  _id INT,
	  _amount NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
  current_balance NUMERIC;
  new_balance NUMERIC;
  result BOOLEAN;
BEGIN
	SELECT balance INTO current_balance FROM accounts WHERE accounts.id = id;  
	SELECT withdraw(_id, _amount) INTO result;

	  IF result THEN
		SELECT balance INTO new_balance FROM accounts WHERE accounts.id = _id;
		INSERT INTO account_transactions (account_id, amount, transaction_type, beginning_balance, ending_balance) VALUES (_id, _amount, 'W', current_balance, new_balance);
		  END IF;
	END;$$;


-- Withdraw 100
CALL p_withdraw(1, 100.0);

SELECT '=======VERIFY ACCOUNT=========';
SELECT * FROM accounts;
SELECT * FROM account_transactions;

DROP PROCEDURE IF EXISTS p_deposit;
CREATE OR REPLACE PROCEDURE p_deposit(
	  _id INT,
	  _amount NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
  current_balance NUMERIC;
  new_balance NUMERIC;
  result BOOLEAN;
BEGIN
	  SELECT balance INTO current_balance FROM accounts WHERE accounts.id = _id;
	  SELECT deposit(_id, _amount) INTO result;

	  IF result THEN
		    SELECT balance INTO new_balance FROM accounts WHERE accounts.id = _id;

		    INSERT INTO account_transactions(account_id, amount, transaction_type, beginning_balance, ending_balance) VALUES (_id, _amount, 'D', current_balance, new_balance);
		  END IF;
	END;$$;


	-- deposit
CALL p_deposit(1, 500.0);

SELECT '=======VERIFY ACCOUNT AFTER P_DEPOSIT=========';
SELECT * FROM accounts;
SELECT * FROM account_transactions;



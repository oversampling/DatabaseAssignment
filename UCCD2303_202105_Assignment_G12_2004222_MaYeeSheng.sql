set linesize 230 
set pagesize 30 
column customer_id format A20
column membership_id format A20
column membership_registration_date format A30
column membership_expiry_date format A25
column customer_dob format A15
column customer_gender format A20
------------------------------------------------------------------------------------------------------------------------------------------
--Query
--======
--Q1
SELECT m.membership_id, c.customer_name, m.membership_username AS "ACCOUNT_USERNAME", m.membership_registration_date 
FROM customer c, membership m 
WHERE c.customer_id=m.customer_id AND m.membership_registration_date = '20-May-20';

--Q2
SELECT membership_id, membership_username AS "ACCOUNT_USERNAME", membership_expiry_date
FROM membership
WHERE membership_expiry_date < current_date;

--Q3
SELECT m.membership_id, c.customer_name, m.membership_username AS "ACCOUNT_USERNAME", c.customer_dob
FROM customer c, membership m
WHERE c.customer_id=m.customer_id AND extract(month from c.customer_dob) = 8;

--Q4
SELECT m.membership_id, c.customer_name, m.membership_username AS "ACCOUNT_USERNAME", c.customer_gender
FROM customer c, membership m
WHERE c.customer_id=m.customer_id AND c.customer_gender = 'Male';

--Q5
SELECT m.membership_id, c.customer_name, m.membership_username AS "ACCOUNT_USERNAME", c.customer_email
FROM customer c, membership m
WHERE c.customer_id=m.customer_id AND c.customer_email LIKE '%@gmail%';

--Q6
SELECT m.membership_id, c.customer_name, m.membership_username AS "ACCOUNT_USERNAME", c.customer_address
FROM customer c, membership m
WHERE c.customer_id=m.customer_id AND c.customer_address LIKE '%Ipoh, Perak';

--Q7
SELECT m.membership_id, c.customer_name, m.membership_username AS "ACCOUNT_USERNAME", count(p.payment_id) "Frequency of purchase", sum(p.payment_total) "Total Expenses (RM)"
FROM customer c, membership m, payment p
WHERE c.customer_id=m.customer_id AND c.customer_id=p.customer_id
GROUP BY m.membership_id, m.membership_username, c.customer_name
ORDER BY sum(p.payment_total) DESC;

--Q8
SELECT count(p.payment_id) "Frequency of purchase", sum(p.payment_total) "Total Expenses (RM)", avg(p.payment_total) "Average Expenses (RM)"
FROM customer c, membership m, payment p
WHERE c.customer_id=m.customer_id AND c.customer_id=p.customer_id;

--Q9
SELECT m.membership_id, c.customer_name, m.membership_username AS "ACCOUNT_USERNAME", avg(p.payment_total) "Average Expenses (RM)"
FROM customer c, membership m, payment p
WHERE c.customer_id=m.customer_id AND c.customer_id=p.customer_id
GROUP BY m.membership_id, m.membership_username, c.customer_name;

--Q10
SELECT payment_method, count(p.payment_id) "Usage Frequency", sum(p.payment_total) "Total Expenses (RM)", avg(p.payment_total) "Average Expenses (RM)"
FROM customer c, membership m, payment p
WHERE c.customer_id=m.customer_id AND c.customer_id=p.customer_id
GROUP BY payment_method;

------------------------------------------------------------------------------------------------------------------------------------------------------------
--Stored Procedure
--=================
--Q1
CREATE OR REPLACE PROCEDURE extend_membership_duration(input_id IN VARCHAR2, month_added IN NUMBER)
IS
BEGIN
  UPDATE membership
  SET membership_expiry_date = ADD_MONTHS(membership_expiry_date, month_added)
  WHERE membership_id = input_id;
  COMMIT;
END;
/

execute extend_membership_duration('NORM001', 2);


--Q2
CREATE OR REPLACE PROCEDURE update_member_uname_pwd (input_id IN VARCHAR2, new_username IN VARCHAR2, new_password IN VARCHAR2)
IS
BEGIN
  UPDATE membership
  SET membership_username = new_username, membership_password = new_password
  WHERE membership_id = input_id;
  COMMIT;
END;
/

execute update_member_uname_pwd('NORM001', 'Tan_Kenny', 'tan29221');


--Q3
CREATE OR REPLACE PROCEDURE update_customer_email (input_id IN VARCHAR2, new_email IN VARCHAR2)
IS
BEGIN
  UPDATE customer
  SET customer_email = new_email
  WHERE customer_id = input_id;
  COMMIT;
END;
/

execute update_customer_email('C007', 'tanalice@gmail.com');


--Q4
CREATE OR REPLACE PROCEDURE add_member_point (input_id IN VARCHAR2, point_added IN NUMBER)
IS
BEGIN
  UPDATE membership
  SET points_collected = points_collected + point_added
  WHERE membership_id = input_id;
  COMMIT;
END;
/

execute add_member_point('NORM001',15);


--Q5
CREATE OR REPLACE PROCEDURE delete_expired_member
IS
BEGIN
  DELETE FROM normal_member
  WHERE normal_member_id IN (SELECT membership_id
                            FROM membership
                            WHERE membership_expiry_date < current_date);

  DELETE FROM VIP_member
  WHERE VIP_member_id IN (SELECT membership_id
                         FROM membership
                         WHERE membership_expiry_date < current_date);

  DELETE FROM membership
  WHERE membership_expiry_date < current_date;

  COMMIT;
END;
/

execute delete_expired_member;


------------------------------------------------------------------------------------------------------------------------------------------------------------
--Function
--=========
--Q1
CREATE OR REPLACE FUNCTION get_member_points(input_id IN VARCHAR2)
  RETURN NUMBER
IS
  member_points NUMBER;
BEGIN
  SELECT points_collected INTO member_points
  FROM membership
  WHERE membership_id = input_id;
  RETURN member_points;
END;
/

SET SERVEROUTPUT ON
DECLARE
  member_ID VARCHAR2(10);
  points_collected NUMBER;
BEGIN
  member_ID := 'NORM001';
  points_collected := get_member_points(member_ID);
  DBMS_OUTPUT.PUT_LINE('The points collected for the member with ID '||member_ID||' is '||points_collected||' points');
END;
/



--Q2
CREATE OR REPLACE FUNCTION get_member_expiry_date(input_id IN VARCHAR2)
  RETURN DATE
IS
  expiry_date DATE;
BEGIN
  SELECT membership_expiry_date INTO expiry_date
  FROM membership
  WHERE membership_id = input_id;
  RETURN expiry_date;
END;
/

SET SERVEROUTPUT ON
DECLARE
  member_ID VARCHAR2(10);
  expiry_date DATE;
BEGIN
  member_ID := 'NORM001';
  expiry_date := get_member_expiry_date(member_ID);
  DBMS_OUTPUT.PUT_LINE('The expiry date of the membership account with ID '||member_ID||' is '||expiry_date);
END;
/



--Q3
CREATE OR REPLACE FUNCTION age_of_customer(input_id IN VARCHAR2)
  RETURN NUMBER
IS
  birth_date DATE;
  current_age NUMBER;
BEGIN
  SELECT customer_dob INTO birth_date
  FROM customer
  WHERE customer_id = input_id;
  current_age := TRUNC((SYSDATE - birth_date)/365.25);
  RETURN current_age;
END;
/

SET SERVEROUTPUT ON
DECLARE
  customer_ID VARCHAR2(10);
  customer_age NUMBER;
BEGIN
  customer_ID := 'C007';
  customer_age := age_of_customer(customer_ID);
  DBMS_OUTPUT.PUT_LINE('The age of the customer with ID '||customer_ID||' is '||customer_age||' years old');
END;
/



--Q4
CREATE OR REPLACE FUNCTION get_customer_email(input_id IN VARCHAR2)
  RETURN VARCHAR2
IS
  email VARCHAR2(50);
BEGIN
  SELECT customer_email INTO email
  FROM customer
  WHERE customer_id = input_id;
  RETURN email;
END;
/

SET SERVEROUTPUT ON
DECLARE
  customer_ID VARCHAR2(10);
  customer_email VARCHAR2(50);
BEGIN
  customer_ID := 'C008';
  customer_email := get_customer_email(customer_ID);
  DBMS_OUTPUT.PUT_LINE('The email of the customer with ID '||customer_ID||' is '||customer_email);
END;
/



--Q5
CREATE OR REPLACE FUNCTION get_member_expenses(input_id IN VARCHAR2)
  RETURN NUMBER
IS
  total_expenses NUMBER(10,2);
BEGIN
  SELECT sum(p.payment_total) INTO total_expenses
  FROM customer c, membership m, payment p
  WHERE m.membership_id = input_id AND m.customer_id=c.customer_id AND c.customer_id=p.customer_id;
  RETURN total_expenses;
END;
/

SET SERVEROUTPUT ON
DECLARE
  member_ID VARCHAR2(10);
  member_expenses NUMBER(10,2);
BEGIN
  member_ID := 'NORM001';
  member_expenses := get_member_expenses(member_ID);
  DBMS_OUTPUT.PUT_LINE('The total expenses of the member with ID '||member_ID||' is RM '||member_expenses);
END;
/
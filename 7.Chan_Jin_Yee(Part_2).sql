--User involved.
drop user sale cascade;
create user sale identified by 123;
grant create session, create table to sale WITH ADMIN OPTION;
alter user sale quota 50m on system;
grant select any table, insert any table, delete any table, update any table to sale;
grant create any procedure to sale;
grant alter any procedure to sale;
grant DROP ANY PROCEDURE to sale;
GRANT EXECUTE ANY PROCEDURE TO sale;
--Query
-- 1. List all transaction handle by employee name Lee Zi Jia
SELECT p.payment_total, p.payment_id, p.payment_date
FROM payment p, employee e
WHERE (p.employee_id = e.employee_id)
AND (e.employee_name = 'Lee Zi Jia')
AND (p.payment_total > 200);

-- 2. List all transaction happen on 31 August 2021 as public holiday.
SELECT SUM(book_sales_quantity) as TOTAL_BOOK_SOLE
FROM sale s, payment p
WHERE s.payment_id = p.payment_id
AND p.payment_date = '31-Aug-21' 
GROUP BY p.payment_date;

-- 3. List all transaction in each month.
SELECT COUNT(payment_id) AS No_Payment_From_12pm_To_4pm,  to_char(payment_date, 'month') as Month
FROM payment
WHERE to_number(payment_time) > 1200
AND to_number(payment_time) < 1600
GROUP BY to_char(payment_date, 'month');

-- 4. List all transaction handled by each employee
SELECT COUNT(p.payment_id) AS NO_OF_PAYMENT, e.employee_name
FROM payment p, employee e
WHERE (p.employee_id = e.employee_id)
and EXTRACT(MONTH FROM payment_date) = 8
GROUP BY e.employee_name
ORDER BY e.employee_name;

--5. List all membership sale base on the membership package.
SELECT COUNT(s.package_id) AS NO_OF_MEMBERSHIP_SALES, s.package_id AS package_id
FROM sale s, payment p
WHERE s.payment_id = p.payment_id
AND s.package_id IS NOT NULL
GROUP BY s.package_id;

--6. List average payment each day in weekday.
SELECT ROUND(AVG(payment_total),2) AS AVERAGE_TOTAL_PAYMENT, to_char(payment_date, 'DAY') AS DAY
FROM payment
WHERE TO_CHAR(payment_date, 'DY') NOT IN ('SAT', 'SUN')
GROUP BY to_char(payment_date, 'DAY');

-- 7. List number of payment method used by customer in August.
SELECT COUNT(payment_method) as NO_OF_PAYMENT_METHOD, payment_method
FROM payment
WHERE EXTRACT(MONTH FROM payment_date) = 8
GROUP BY payment_method;

-- 8. List quantity of book sole base on each book title.
SELECT SUM(s.book_sales_quantity) as QUANTITY, b.book_title as BOOK_NAME
FROM payment p, sale s, book b
WHERE s.payment_id = p.payment_id
AND s.book_code = b.book_code
AND EXTRACT(MONTH FROM payment_date) = 8
GROUP BY b.book_title;

-- 9. List amount of transaction in each payment method.
SELECT SUM(payment_total) AS PAYMENT_MADE_IN_CASH, payment_method
FROM payment
WHERE EXTRACT(MONTH FROM payment_date) = 8
group by payment_method;

select payment_method from payment
where INITCAP(payment_method) = 'Cash';

--10. List amount of transaction in each branch.
SELECT SUM(p.payment_total) AS TOTAL_PAYMENT, b.branch_name
FROM payment p, employee e, branch b
WHERE p.employee_id = e.employee_id
and b.branch_no = e.branch_id
and EXTRACT(MONTH FROM payment_date) = 8
group by  b.branch_name;


--Procedural call
--1. update book sole for certain sale.
CREATE OR REPLACE PROCEDURE update_sale_quantity 
(current_sale_id IN VARCHAR2, new_quantity IN NUMBER)
IS 
temp_sale_id VARCHAR2(10);
BEGIN
SELECT sale_id into temp_sale_id FROM sale WHERE sale_id = current_sale_id and book_code IS NOT NULL;
UPDATE sale SET book_sales_quantity = new_quantity WHERE sale_id = temp_sale_id;
dbms_output.put_line('Sucessfully update sale quantity for sale id: ' || temp_sale_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Invalid Args');
COMMIT;
END;
/

--2. Delete a sale
CREATE OR REPLACE PROCEDURE delete_sale
(current_sale_id IN VARCHAR2)
IS 
temp_sale_id varchar2(10);
BEGIN
SELECT sale_id into temp_sale_id FROM sale WHERE sale_id = current_sale_id;
DELETE sale
WHERE sale_id = current_sale_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Invalid Args');
COMMIT;
END;
/

-- 3. Update new membership package sale.
CREATE OR REPLACE PROCEDURE modity_sale_membership_package
(current_sale_id IN VARCHAR2, new_package_id IN VARCHAR2)
IS 
temp_sale_id varchar2(10);
temp_package_id varchar2(10);
BEGIN
SELECT sale_id into temp_sale_id FROM sale WHERE sale_id = current_sale_id;
SELECT package_id into temp_package_id FROM membership_package where package_id = new_package_id;
UPDATE sale
SET package_id = new_package_id
WHERE sale_id = current_sale_id;
dbms_output.put_line('Sucessfully update membership package sole for sale id: ' || temp_sale_id || ' with new package: ' || new_package_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Invalid Args');
COMMIT;
END;
/

--4. Insert new payment
CREATE OR REPLACE PROCEDURE insert_data_to_payment
(n_employee_id IN VARCHAR2, n_customer_id IN VARCHAR2, payment_method IN VARCHAR2, payment_total IN number)
IS
    e_id varchar2(10);
    c_id varchar2(10);
    p_id varchar2(10);
    p_id_1 number(10);
BEGIN
    IF payment_method NOT IN ('Cash', 'Credit Card') THEN
        DBMS_OUTPUT.PUT_LINE('Wrong payment method');
    ELSE
        SELECT employee_id INTO e_id FROM employee WHERE employee_id = n_employee_id;
        SELECT customer_id INTO c_id FROM customer where customer_id = n_customer_id;
        select payment_id INTO p_id from payment where payment_id = ( select max(payment_id) from payment );
        p_id_1 := to_number(substr(p_id, 2, 3));
        INSERT INTO payment VALUES ('P'||(p_id_1 + 1), e_id, c_id, to_date(sysdate, 'dd-Mon-yy'), TO_CHAR(sysdate, 'HH24MI'), payment_method, payment_total);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Wrong employee or customer id');
COMMIT;
END;
/

EXECUTE insert_data_to_payment('E001', 'C001', 'Cash', 334);

-- 5. Insert new sale
CREATE OR REPLACE PROCEDURE insert_data_to_sale
(n_payment_id IN varchar2, n_book_code IN varchar2, n_package_id IN varchar2, book_sales_quantity IN number)
IS
p_id VARCHAR2(10);
b_code VARCHAR2(10);
pack_id VARCHAR2(10);
s_id varchar2(10);
s_id_1 number(10);
BEGIN
    select sale_id INTO s_id from sale where sale_id = ( select max(sale_id) from sale );
    s_id_1 := to_number(substr(s_id, 2, 3));
    SELECT payment_id INTO p_id FROM payment WHERE payment_id = n_payment_id;
    IF n_book_code IS NOT NULL AND n_package_id IS NOT NULL THEN
        SELECT book_code INTO b_code FROM book WHERE book_code = n_book_code;
        SELECT package_id INTO pack_id FROM membership_package WHERE package_id = n_package_id;
        INSERT into sale values('S' || (s_id_1 + 1), p_id, b_code, pack_id, book_sales_quantity);
    ELSIF n_book_code IS NOT NULL AND n_package_id IS NULL THEN
        SELECT book_code INTO b_code FROM book WHERE book_code = n_book_code;
        INSERT into sale values('S' || (s_id_1 + 1), p_id, b_code, NULL, book_sales_quantity);
    ELSIF n_book_code IS NULL AND n_package_id IS NOT NULL THEN
        SELECT package_id INTO pack_id FROM membership_package WHERE package_id = n_package_id;
        INSERT into sale values('S' || (s_id_1 + 1), p_id, NULL, pack_id, NULL);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cannot NULL in all argument');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Successfully Insert To Sale');
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Invalid Arguments');
COMMIT;
END;
/
EXECUTE insert_data_to_sale('001', NULL, NULL, NULL);
EXECUTE insert_data_to_sale('P001', NULL, 'PK001', NULL);

--function
--1. Sum up gross total payment need to pay by customer
CREATE OR REPLACE FUNCTION total_payment(n_payment_id IN VARCHAR2)
RETURN NUMBER
IS
total_payment NUMBER := 0;
BEGIN
    FOR a in (
        select s.sale_id, (b.book_price * s.book_sales_quantity )+ mp.package_price total_sale_payment
        from sale s, book b, membership_package mp 
        where s.book_code = b.book_code 
        and s.package_id = mp.package_id
        and s.book_code IS NOT NULL
        and s.package_id IS NOT NULL
        and s.payment_id = n_payment_id
        union
        select s.sale_id, (b.book_price * s.book_sales_quantity ) total_sale_payment
        from sale s, book b
        where s.book_code = b.book_code
        and s.package_id IS NULL
        and s.payment_id = n_payment_id
        union
        select s.sale_id, mp.package_price total_sale_payment
        from sale s, membership_package mp 
        where s.package_id = mp.package_id
        and s.book_code IS NULL
        and s.payment_id = n_payment_id
    ) LOOP 
        total_payment := total_payment + to_number(a.total_sale_payment);
    END LOOP;
    dbms_output.put_line('Total payment for id: ' || n_payment_id || ' is ' ||total_payment);
RETURN total_payment;
END;
/

DECLARE
total_sale_payment NUMBER;
BEGIN
total_sale_payment := total_payment('P004');
DBMS_OUTPUT.PUT_LINE('Total payment is '||
total_sale_payment);
END;
/
--2. Identify total discout of payment of a customer
CREATE OR REPLACE FUNCTION calculate_discount(n_payment_id IN VARCHAR2)
RETURN NUMBER
IS
total_payment_sale NUMBER := total_payment(n_payment_id);
total_discount_rate NUMBER(10, 2);
BEGIN
    select m.membership_discount into total_discount_rate
    from payment p, customer c, membership m
    where p.customer_id = c.customer_id
    and c.customer_id = m.customer_id
    and p.payment_id = n_payment_id;
    DBMS_OUTPUT.PUT_LINE('Total number of discount: ' || (total_payment_sale * total_discount_rate) || ' with discount rate: ' || total_discount_rate);
RETURN (total_payment_sale * total_discount_rate);
END;
/

DECLARE
total_discount NUMBER(10, 2);
BEGIN
total_discount := calculate_discount('P004');
END;
/

--3. Calculate total net payment
CREATE OR REPLACE FUNCTION calculate_net_payment(n_payment_id IN VARCHAR2)
RETURN NUMBER
IS
total_payment_sale NUMBER;
total_discount NUMBER;
BEGIN
total_payment_sale := total_payment('P004');
total_discount :=  calculate_discount('P004');
DBMS_OUTPUT.put_line('Total net payment is: ' || (total_payment_sale - total_discount));
return (total_payment_sale - total_discount);
END;
/

DECLARE
total_net_payment NUMBER;
BEGIN
total_net_payment := calculate_net_payment('P004');
DBMS_OUTPUT.PUT_LINE(total_net_payment);
END;
/
--4. Get total return for a payment
CREATE OR REPLACE FUNCTION calculate_return(n_payment_id IN VARCHAR2, total_money_gave IN NUMBER)
RETURN NUMBER
IS
total_payment_net NUMBER;
return_amount NUMBER;
BEGIN
total_payment_net := calculate_net_payment(n_payment_id);
return_amount := total_money_gave - total_payment_net;
IF return_amount < 1 then
    return_amount := 0;
end if;
dbms_output.put_line('Return amount: ' || return_amount || ' with money gave: ' || total_money_gave);
RETURN return_amount;
END;
/

DECLARE
total_net_payment NUMBER;
BEGIN
total_net_payment := calculate_return('P004', 3000);
DBMS_OUTPUT.PUT_LINE(total_net_payment);
END;
/

--5. Sum up total income for this day
CREATE OR REPLACE FUNCTION total_income_in_day(n_date date)
RETURN NUMBER
IS
total_in_the_day NUMBER;
BEGIN
select sum(payment_total) into total_in_the_day
from payment
where payment_date =  n_date;
RETURN total_in_the_day;
END;
/

DECLARE
total_in_the_day NUMBER;
BEGIN
total_in_the_day := total_income_in_day('21-Aug-21');
DBMS_OUTPUT.PUT_LINE(total_in_the_day);
END;
/

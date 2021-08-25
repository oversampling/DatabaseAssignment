connect system/oracle
start C:\Users\User\Downloads\MySQL\Wisdom.sql
SET SERVEROUTPUT ON

--Query 1
SELECT book_title AS "Book Title", book_price AS "Price(RM)"
FROM BOOK 
WHERE book_price > 100
ORDER BY book_title;

--Query 2
SELECT book_code AS ISBN, book_title AS "Book Title"
FROM BOOK 
WHERE book_author = 'J.K. Rowling'
ORDER BY book_code;

--Query 3
SELECT COUNT(sales_personnel_id) AS "Total Sales Personnel", 
AVG(bonus) AS "Average Bonus(RM)"
FROM SALES_PERSONNEL;

--Query 4
SELECT employee_id AS "Emp ID", employee_name AS Name,
employee_salary AS "Salary(RM)"
FROM EMPLOYEE
WHERE employee_salary >= 5000
ORDER BY employee_id;

--Query 5
SELECT branch_no, stock_left AS Stocks
FROM BOOK b, BOOK_BRANCH br
WHERE b.book_code = br.book_code
AND book_title = 'The Odyssey'
ORDER BY branch_no;

--Query 6
SELECT membership_id AS "VIP ID",
customer_name AS "Customer Name",
customer_email AS Email
FROM CUSTOMER c, MEMBERSHIP m
WHERE c.customer_id = m.customer_id
AND membership_id LIKE 'VIP%'
ORDER BY membership_id;

--Query 7
SELECT SUM(stock_left) AS "Total Stocks"
FROM BOOK_BRANCH;

--Query 8
SELECT book_code AS ISBN, book_title AS "Book Title",
book_price AS "Price(RM)", book_author AS Author
FROM BOOK
WHERE book_publisher = 'Galgotia Publications Pvt Ltd'
ORDER BY book_code;

--Query 9
SELECT employee_id AS "Emp ID", employee_name AS "Top Management",
meeting_date AS "Date", meeting_time AS "Time",
meeting_location AS "Location"
FROM EMPLOYEE e, TOP_MANAGEMENT tm
WHERE e.employee_id = tm.top_manage_id;

--Query 10
SELECT level_id AS "Level ID", level_name AS "Level Name",
account_username AS "Username", account_password AS "Password"
FROM LEVELS l, ADMIN a
WHERE l.level_id = a.admin_id
AND level_id = 'L01';

--Procedure 1
CREATE OR REPLACE PROCEDURE update_manager_bonus (
current_manager_id IN VARCHAR2,
current_bonus IN CHAR )
IS BEGIN
UPDATE MANAGER
SET bonus = current_bonus WHERE manager_id = current_manager_id;
END;
/

EXECUTE update_manager_bonus('E002',1800);

--Procedure 2
CREATE OR REPLACE PROCEDURE update_book_branch_stock_left (
current_book_code IN VARCHAR2,
current_branch_no IN CHAR,
current_stock_left IN NUMBER )
IS BEGIN
UPDATE BOOK_BRANCH
SET stock_left = curren_stock_left WHERE book_code = current_book_code
AND branch_no = current_branch_no;
END;
/

EXECUTE update_book_branch_stock_left('0143136666','BR01',15);

--Procedure 3
CREATE OR REPLACE PROCEDURE update_employee_salary (
current_employee_id IN VARCHAR2,
current_employee_salary IN NUMBER )
IS BEGIN
UPDATE EMPLOYEE
SET employee_salary = current_employee_salary WHERE employee_id = current_employee_id;
END;
/

EXECUTE update_employee_salary('E002',8000);

--Procedure 4
CREATE OR REPLACE PROCEDURE update_admin_password (
current_admin_id IN VARCHAR2
current_account_username IN VARCHAR2,
current_account_password IN VARCHAR2 )
IS BEGIN
UPDATE ADMIN
SET admin_id = current_admin_id WHERE account_username = current_account_username
AND account_password = current_account_password;
END;
/

EXECUTE update_admin_password ('L01','top111','top1234');

--Procedure 5
CREATE OR REPLACE PROCEDURE update_driving_duration (
current_van_driver_id IN VARCHAR2,
current_car_plate_num IN VARCHAR2,
current_driving_duration IN NUMBER )
IS BEGIN 
UPDATE VAN_DRIVER
SET van_driver_id = current_van_driver_id WHERE car_plate_num = current_car_plate_num
AND driving_duration = current_driving_duration;
END;
/

EXECUTE update_driving_duration('D18','MWM3226',6);

--Function 1
CREATE OR REPLACE FUNCTION book_title
(ISBN VARCHAR2)
RETURN VARCHAR2 IS
booktile BOOK.book_title%TYPE;
BEGIN
SELECT book_title INTO booktitle FROM BOOK
WHERE book_code = ISBN;
RETURN ('Book Title: '||ISBN||' - '||UPPER(booktitle));
END book_title;
/

DECLARE
ISBN VARCHAR2(10):='9780525541';
BEGIN
DBMS_OUTPUT.PUT_LINE(book_title(ISBN));
END;
/

--Function 2
CREATE OR REPLACE FUNCTION get_branch_address
(branchname VARCHAR2)
RETURN VARCHAR2 IS
branchaddr BRANCH.branch_address%TYPE;
BEGIN
SELECT branch_address INTO branchaddr FROM BRANCH
WHERE branch_name = branchname;
RETURN ('Branch: '||branchname||' at '||branchaddr);
END get_branch_address;
/

SELECT get_branch_address('NS Downtown Bookstore') FROM DUAL;

--Function 3
CREATE OR REPLACE FUNCTION get_update_stocks
(old_stocks IN NUMBER, add_stocks IN NUMBER)
RETURN NUMBER
IS
new_stocks NUMBER;
BEGIN
new_stocks:=old_stocks+add_stocks;
RETURN new_stocks;
END;
/

DECLARE
update_stocks NUMBER:= 10;
ori_stocks BOOK_BRANCH.stock_left%TYPE;
newly_stocks BOOK_BRANCH.stock_left%TYPE;
BEGIN
SELECT stock_left INTO ori_stocks
FROM BOOK_BRANCG
WHERE book_code = '9780525541'
AND branch_no = 'BR03';
newly_stocks:=get_update_stocks(ori_stocks, update_stocks);
DBMS_OUTPUT.PUT_LINE('Previous stocks left is '||ori_stocks);
DBMS_OUTPUT.PUT_LINE('Update stocks left is '||newly_stocks);
END;
/

--Function 4
CREATE OR REPLACE FUNCTION bbok_price_change
(price_now IN NUMBER, percentage IN NUMBER)
RETURN NUMBER IS 
new_price NUMBER;
BEGIN 
new_price:=price_now*percentage;
RETURN new_price;
END;
/

DECLARE
percentage NUMBER:=0.88;
old_price BOOK.book_price%TYPE;
latest_price BOOK.book_price%TYPE;
BEGIN
SELECT book_price INTO old_price
FROM BOOK
WHERE book_code='8175157526';
latest_price:=book_price_change(old_price,percentage);
DBMS_OUTPUT.PUT_LINE('Original price: '||old_price);
DBMS_OUTPUT.PUT_LINE('New price: '||latest_price);
END;
/

--Function 5
CREATE OR REPLACE FUNCTION totalcustomer
RETURN NUMBER IS
total number(2):=0;
BEGIN
SELECT COUNT(*) INTO TOTAL
FROM CUSTOMER
RETURN TOTAL;
END;
/

DECLARE 
c NUMBER(2);
BEGIN
c:=totalcustomer();
DBMS_OUTPUT.PUT_LINE('Total no. of Customers: '||c);
END;
/


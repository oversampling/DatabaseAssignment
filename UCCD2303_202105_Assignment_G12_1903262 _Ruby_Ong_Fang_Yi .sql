connect system/oracle
start C:\Users\User\Downloads\MySQL\Wisdom.sql
SET SERVEROUTPUT ON

--Query 1
SELECT employee_id, employee_name
FROM employee e JOIN designation d
ON e.designation_id=d.designation_id
WHERE d.level_id='L05';

--Query 2
SELECT employee_name, staff_id
FROM employee e, staff s
WHERE e.employee_id=s.staff_id
AND s.employee_manger='E002';

--Query 3
SELECT employee_id, employee_name
FROM employee
WHERE employee_gender='Male'
AND branch_id='BR05';

--Query 4
SELECT employee_name "Name", employee_dob "DOB", (SYSDATE-employee_dob)/365.25 "Age"
FROM employee
ORDER BY employee_name;

--Query 5
SELECT employee_name "Name", employee_gender "Gender"
FROM employee e JOIN full_time f
ON e.employee_id=f.full_time_id
WHERE to_char(employee_dob, 'MM')='09';

--Query 6
SELECT branch_no, branch_name, call_num
FROM customer_service c JOIN branch b
USING (branch_no)
WHERE branch_no<>'BR01';

--Query 7
SELECT e.employee_name, m.manager_id
FROM employee e, manager m
WHERE e.employee_id=m.manager_id(+)
ORDER BY employee_name;

--Query 8
SELECT van_driver_id, car_plate_num
FROM van_driver
WHERE driving_duration >= 2
AND driving_permit='Allowed';

--Query 9
SELECT employee_name "Name", designation_name "Designation"
FROM employee e JOIN designation d
ON e.designation_id=d.designation_id
WHERE employee_salary BETWEEN 500 AND 1900
ORDER BY employee_salary DESC;

--Query 10
SELECT level_name "Level name", account_username "Username", account_password "Password"
FROM admin a, levels l
WHERE a.admin_id=l.level_id
AND level_id='L03';

--Procedure 1
CREATE OR REPLACE PROCEDURE update_leave
(current_full_id IN VARCHAR2, update_leave_quantity IN NUMBER)
IS
BEGIN
UPDATE full_time
SET leave_allowance=leave_allowance+update_leave_quantity
WHERE full_time_id=current_full_id;
COMMIT;
END;
/

EXECUTE update_leave('E005', 5);

--Procedure 2
CREATE OR REPLACE PROCEDURE update_driver_permit 
(cur_driver_id IN VARCHAR2, cur_car_num IN VARCHAR2, 
cur_permit IN VARCHAR2)
IS
BEGIN
UPDATE van_driver
SET driving_permit=cur_permit
WHERE van_driver_id=cur_driver_id
AND car_plate_num=cur_car_num; 
COMMIT;
END;
/

EXECUTE update_driver_permit('D19','PPP421O','Not Allowed');

--Procedure 3
CREATE OR REPLACE PROCEDURE delete_account
(cur_admin_id IN ADMIN.ADMIN_ID%TYPE)
IS
BEGIN
DELETE ADMIN 
WHERE admin_id=cur_admin_id;
COMMIT;
END;
/

EXECUTE delete_account('L01');

--Procedure 4
CREATE OR REPLACE PROCEDURE insert_new_designation(
new_des_id IN DESIGNATION.DESIGNATION_ID%TYPE,
new_des_name IN DESIGNATION.DESIGNATION_NAME%TYPE,
new_lvl_id IN DESIGNATION.LEVEL_ID%TYPE)
IS
BEGIN
INSERT INTO DESIGNATION
("DESIGNATION_ID", "DESIGNATION_NAME", "LEVEL_ID") 
VALUES (new_des_id, new_des_name, new_lvl_id);
COMMIT;
END;
/

EXECUTE insert_new_designation('E123','ABCDEFGHIJK','L05');

--Procedure 5
CREATE OR REPLACE PROCEDURE select_employee(
cur_emp_id IN EMPLOYEE.EMPLOYEE_ID%TYPE,
show_emp OUT EMPLOYEE.EMPLOYEE_NAME%TYPE,
show_gender OUT EMPLOYEE.EMPLOYEE_GENDER%TYPE,
show_contact OUT EMPLOYEE.EMPLOYEE_CONTACT%TYPE)
IS
BEGIN
SELECT EMPLOYEE_NAME, EMPLOYEE_GENDER, EMPLOYEE_CONTACT
INTO show_emp, show_gender, show_contact 
FROM EMPLOYEE 
WHERE employee_id=cur_emp_id;
END;
/

DECLARE
show_emp EMPLOYEE.EMPLOYEE_NAME%TYPE;
show_gender EMPLOYEE.EMPLOYEE_GENDER%TYPE;
show_contact EMPLOYEE.EMPLOYEE_CONTACT%TYPE;
BEGIN
select_employee('E006',show_emp,show_gender,show_contact);
DBMS_OUTPUT.PUT_LINE('Name: '|| show_emp);
DBMS_OUTPUT.PUT_LINE('Gender: ' || show_gender);
DBMS_OUTPUT.PUT_LINE('Contact:(+60)' || show_contact);
END;
/

--Function 1
CREATE OR REPLACE FUNCTION renew_duration
(old_dur IN NUMBER, add_dur IN NUMBER)
RETURN NUMBER
IS
new_dur NUMBER;
BEGIN
new_dur:=old_dur+add_dur;
RETURN new_dur;
END;
/

DECLARE
update_dur NUMBER:=10;
ori_dur VAN_DRIVER.DRIVING_DURATION%TYPE;
newly_dur VAN_DRIVER.DRIVING_DURATION%TYPE;
BEGIN
SELECT driving_duration INTO ori_dur
FROM van_driver
WHERE van_driver_id='D17';
newly_dur := renew_duration(ori_dur,update_dur);
DBMS_OUTPUT.PUT_LINE('Previous driving duration: '||ori_dur);
DBMS_OUTPUT.PUT_LINE('Driver D17 new driving duration is: '||newly_dur);
END;
/


--Function 2
CREATE OR REPLACE FUNCTION newly_salesamt
(prev_sales IN NUMBER, cur_sales IN NUMBER, profit IN NUMBER)
RETURN NUMBER
IS
total_sales NUMBER;
BEGIN
total_sales:=(prev_sales+cur_sales+(profit*0.02));
RETURN total_sales;
END;
/

DECLARE
newnumSales NUMBER:= 5555;
newnumProfit NUMBER:= 1234;
old_sales SALES_PERSONNEL.SALES_AMOUNT%TYPE;
up_sales SALES_PERSONNEL.SALES_AMOUNT%TYPE;
BEGIN
SELECT sales_amount INTO old_sales
FROM sales_personnel
WHERE sales_personnel_id='D14';
up_sales:=newly_salesamt(old_sales,newnumSales,newnumProfit);
DBMS_OUTPUT.PUT_LINE('Previous sales amount: RM'||old_sales);
DBMS_OUTPUT.PUT_LINE('New sales amount: RM'||newnumSales);
DBMS_OUTPUT.PUT_LINE('New profit add up: RM'||newnumProfit);
DBMS_OUTPUT.PUT_LINE('Current sales amount: RM'||up_sales);
END;
/

--Function 3
CREATE OR REPLACE FUNCTION add_sal
(sal_now IN NUMBER, extra_working_hrs IN NUMBER, pt_bonus IN NUMBER)
RETURN NUMBER
IS
new_salary NUMBER;
BEGIN
new_salary:= sal_now + (extra_working_hrs*pt_bonus);
RETURN new_salary;
END;
/

DECLARE
extraWork NUMBER:= 10;
extraBonus NUMBER:= 4;
prev_sal EMPLOYEE.EMPLOYEE_SALARY%TYPE;
latestsal EMPLOYEE.EMPLOYEE_SALARY%TYPE;
BEGIN
SELECT employee_salary INTO prev_sal
FROM employee
WHERE employee_id='E011';
latestsal:= add_sal(prev_sal, extraWork, extraBonus);
DBMS_OUTPUT.PUT_LINE('Previous salary: '||prev_sal);
DBMS_OUTPUT.PUT_LINE('OT hours: '||extraWork);
DBMS_OUTPUT.PUT_LINE('Bonus: '||extraBonus);
END;
/

--Function 4
CREATE OR REPLACE FUNCTION add_Dates
(oriDate IN DATE, delayNo IN NUMBER)
RETURN date
IS
newlyDate DATE;
BEGIN
newlyDate:= oriDate + delayNo;
RETURN newlyDate;
END;
/

DECLARE
delayDay1 NUMBER:=7;
delayDay2 NUMBER:=14;
lateDate1 DATE;
lateDate2 DATE;
prevDate TOP_MANAGEMENT.MEETING_DATE%TYPE;
BEGIN
SELECT meeting_date INTO prevDate
FROM top_management
WHERE top_manage_id='E001';
lateDate1:= add_Dates(prevDate, delayDay1);
lateDate2:= add_Dates(prevDate, delayDay2);
DBMS_OUTPUT.PUT_LINE('Initial meeting date: '||prevDate);
DBMS_OUTPUT.PUT_LINE('1st Rescheduled Meeting, '||delayDay1||' days later.');
DBMS_OUTPUT.PUT_LINE('1st Rescheduled Meeting date: '||lateDate1);
DBMS_OUTPUT.PUT_LINE('2nd Rescheduled Meeting, '||delayDay2||' days later.');
DBMS_OUTPUT.PUT_LINE('2nd Rescheduled Meeting date: '||lateDate2);
END;
/

--Function 5
CREATE OR REPLACE FUNCTION add_bdate
(bDate IN DATE, dayNo IN NUMBER)
RETURN DATE
IS
newlyDate DATE;
BEGIN
newlyDate:= bDate + dayNo;
RETURN newlyDate;
END;
/

DECLARE
dayAfter NUMBER:=20;
results DATE;
bdayDate EMPLOYEE.EMPLOYEE_DOB%TYPE;
BEGIN
SELECT employee_dob INTO bdayDate
FROM employee
WHERE employee_id='E007';
results:= add_bdate(bdayDate, dayAfter);
DBMS_OUTPUT.PUT_LINE(TO_CHAR (bdayDate,'"Employee E007''s birthday is on" DD"th of" fmMonth"."'));
DBMS_OUTPUT.PUT_LINE(TO_CHAR (results,'"It is Day" DD "of" fmMonth" 20 days after employee E007''s birthday."'));
END;
/



















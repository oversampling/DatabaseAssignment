-- You can edit this by pressing . in your keyboard

drop table customer cascade constraints;
drop table membership cascade constraints;
drop table normal_member cascade constraints;
drop table VIP_member cascade constraints;
drop table book cascade constraints;
drop table branch cascade constraints;
drop table book_branch cascade constraints;
drop table category cascade constraints;
drop table reference_book cascade constraints;
drop table fiction cascade constraints;
drop table non_fiction cascade constraints;
drop table has_category cascade constraints;
drop table levels cascade constraints;
drop table admin cascade constraints;
drop table designation cascade constraints;
drop table customer_service cascade constraints;
drop table sales_personnel cascade constraints;
drop table van_driver cascade constraints;
drop table employee cascade constraints;
drop table manager cascade constraints;
drop table staff cascade constraints;
drop table top_management cascade constraints;
drop table full_time cascade constraints;
drop table part_time cascade constraints;
drop table membership_package cascade constraints;
drop table payment cascade constraints;
drop table sale cascade constraints;

create table customer(
   customer_id  varchar2(10)  not null,
   customer_name  varchar2(30)  not null,
   customer_gender  varchar2(10),
   customer_address  varchar2(100),
   customer_email  varchar2(50),
   customer_dob  date,
CONSTRAINT customer_id_pk primary key(customer_id)
);

create table membership(
   membership_id  varchar2(10)  not null,
   customer_id  varchar2(10)  not null,
   membership_discount  number(3,2),
   membership_expiry_date  date,
   membership_registration_date  date,
   membership_username  varchar2(30),
   membership_password  varchar2(30),
   points_collected  number(3),
CONSTRAINT membership_id_pk primary key(membership_id),
CONSTRAINT membership_cust_id_fk foreign key(customer_id) references customer(customer_id)
);

create table normal_member(
   normal_member_id  varchar2(10)  not null,
   yearly_discount  number(3,2),
CONSTRAINT normal_mem_id_pk primary key(normal_member_id),
CONSTRAINT normal_mem_id_fk foreign key (normal_member_id) references membership(membership_id)
);

create table VIP_member(
   VIP_member_id  varchar2(10)  not null,
   monthly_discount  number(3,2),
CONSTRAINT VIP_mem_id_pk primary key(VIP_member_id),
CONSTRAINT VIP_mem_id_fk foreign key (VIP_member_id) references membership(membership_id)
);

create table book(
   book_code  varchar2(10)  not null,
   book_title  varchar2(50)  not null,
   book_price  number(5,2),
   book_description  varchar2(100),
   book_language  varchar2(20),
   book_author  varchar2(30),
   book_publisher  varchar2(30),
CONSTRAINT book_code_pk primary key(book_code)
);

create table branch(
   branch_no  varchar2(10)  not null,
   branch_address  varchar2(100),
   branch_name  varchar2(50),
   branch_open_time  varchar(10),
   branch_close_time  varchar(10),
CONSTRAINT branch_no_pk primary key(branch_no)
);

create table book_branch(
   book_code  varchar2(10)  not null,
   branch_no  varchar2(10)  not null,
   stock_left  number(5),
CONSTRAINT book_branch_pk primary key(book_code,branch_no),
CONSTRAINT book_code_fk foreign key(book_code) references book(book_code),
CONSTRAINT branch_no_fk foreign key(branch_no) references branch(branch_no)
);

create table category(
   category_id  varchar2(10)  not null,
   category_name  varchar2(50)  not null,
CONSTRAINT category_id_pk primary key(category_id)
);

create table reference_book(
   ref_book_id  varchar2(10)  not null,
   subject  varchar2(50),
   education_level  varchar2(50),
CONSTRAINT ref_book_id_pk primary key(ref_book_id),
CONSTRAINT ref_book_id_fk foreign key (ref_book_id) references category(category_id)
);

create table fiction(
   fiction_id  varchar2(10)  not null,
   book_series_name  varchar2(50)  not null,
CONSTRAINT fiction_id_id_pk primary key(fiction_id),
CONSTRAINT fiction_id_fk foreign key (fiction_id) references category(category_id)
);

create table non_fiction(
   non_fiction_id  varchar2(10)  not null,
   book_series_name  varchar2(50)  not null,
CONSTRAINT non_fiction_id_pk primary key(non_fiction_id),
CONSTRAINT non_fiction_id_fk foreign key (non_fiction_id) references category(category_id)
);

create table has_category(
   book_code  varchar2(10)  not null,
   category_id  varchar2(10)  not null,
CONSTRAINT has_category_pk primary key(book_code,category_id),
CONSTRAINT book_code_fk_2 foreign key(book_code) references book(book_code),
CONSTRAINT category_id_fk foreign key(category_id) references category(category_id)
);

create table levels(
   level_id  varchar2(10)  not null,
   level_name  varchar2(50)  not null,
CONSTRAINT level_id_pk primary key(level_id)
);

create table admin(
   admin_id  varchar2(10)  not null,
   account_username  varchar2(50),
   account_password  varchar2(50),
CONSTRAINT admin_id_pk primary key(admin_id),
CONSTRAINT admin_id_fk foreign key (admin_id) references levels(level_id)
);

create table designation(
   designation_id  varchar2(10)  not null,
   designation_name  varchar2(50)  not null,
   level_id  varchar2(10)  not null,
CONSTRAINT designation_id_pk primary key(designation_id),
CONSTRAINT level_id_fk foreign key(level_id) references levels(level_id)
);

create table customer_service(
   cust_service_id  varchar2(10)  not null,
   call_num  number(20),
   branch_no VARCHAR2(10),
CONSTRAINT cust_service_id_pk primary key(cust_service_id),
CONSTRAINT cust_service_id_fk foreign key (cust_service_id) references designation(designation_id ),
CONSTRAINT cust_service_branch_no_fk foreign key (branch_no) references branch(branch_no)
);

create table sales_personnel(
   sales_personnel_id  varchar2(10)  not null,
   sales_amount  number(10,2),
   bonus  number(10,2),
CONSTRAINT sales_personnel_id_pk primary key(sales_personnel_id),
CONSTRAINT sales_personnel_id_fk foreign key (sales_personnel_id) references designation(designation_id )
);

create table van_driver(
   van_driver_id  varchar2(10)  not null,
   car_plate_num  varchar2(20),
   driving_duration  number(10,2),
   driving_permit  varchar2(20),
CONSTRAINT van_driver_id_pk primary key(van_driver_id),
CONSTRAINT van_driver_id_fk foreign key (van_driver_id) references designation(designation_id)
);

create table employee(
   employee_id  varchar2(10)  not null,
   employee_name  varchar2(30)  not null,
   employee_gender  varchar2(10),
   employee_contact  varchar2(15),
   employee_dob  date,
   employee_salary  number(10,2),
   designation_id  varchar2(10),
   branch_id  varchar2(10),
CONSTRAINT employee_id_pk primary key(employee_id),
CONSTRAINT designation_id_fk foreign key(designation_id) references designation(designation_id),
CONSTRAINT branch_id_fk foreign key(branch_id) references branch(branch_no)
);

create table manager(
   manager_id  varchar2(10)  not null,
   bonus  number(10,2),
CONSTRAINT manager_id_pk primary key(manager_id),
CONSTRAINT manager_id_fk foreign key (manager_id) references employee(employee_id)
);

create table staff(
   staff_id  varchar2(10)  not null,
   employee_manger  varchar2(30),
CONSTRAINT staff_id_pk primary key(staff_id),
CONSTRAINT staff_id_fk foreign key (staff_id) references employee(employee_id)
);

create table top_management(
   top_manage_id  varchar2(10)  not null,
   meeting_date  date,
   meeting_time  varchar2(10),
   meeting_location  varchar2(50),
CONSTRAINT top_manage_id_pk primary key(top_manage_id),
CONSTRAINT top_manage_id_fk foreign key (top_manage_id) references employee(employee_id)
);

create table full_time(
   full_time_id  varchar2(10)  not null,
   leave_allowance  number(10,2),
   working_hours  number(10,2),
CONSTRAINT full_time_id_pk primary key(full_time_id),
CONSTRAINT full_time_id_fk foreign key (full_time_id) references employee(employee_id)
);

create table part_time(
   part_time_id  varchar2(10)  not null,
   hourly_rate  number(10,2),
   working_hours  number(10,2),
CONSTRAINT part_time_id_pk primary key(part_time_id),
CONSTRAINT part_time_id_fk foreign key (part_time_id) references employee(employee_id)
);

create table membership_package(
   package_id  varchar2(10)  not null,
   package_duration  number(3)  not null,
   package_discount  number(3,2),
   package_price  number(10,2),
CONSTRAINT package_id_pk primary key(package_id)
);

create table payment(
   payment_id  varchar2(10)  not null,
   employee_id  varchar2(10)  not null,
   customer_id  varchar2(10)  not null,
   payment_date  date,
   payment_time  varchar2(10),
   payment_method  varchar2(30),
   payment_total  number(10,2),
CONSTRAINT payment_id_pk primary key(payment_id),
CONSTRAINT employee_id_fk foreign key(employee_id) references employee(employee_id),
CONSTRAINT customer_id_fk foreign key(customer_id) references customer(customer_id)
);

create table sale(
   sale_id  varchar2(10)  not null,
   payment_id  varchar2(10)  not null,
   book_code  varchar2(10),
   package_id  varchar2(10),
   book_sales_quantity  number(10),
CONSTRAINT sale_id_pk primary key(sale_id),
CONSTRAINT payment_id_fk foreign key(payment_id) references book(book_code),
CONSTRAINT book_code_sale_fk foreign key(book_code) references customer(customer_id),
CONSTRAINT package_id_fk foreign key(package_id) references membership_package(package_id)
);


drop user cust1 cascade;
drop user member1 cascade;
drop user staff1 cascade;
drop user admin1 cascade;

drop role customer;
drop role membership;
drop role staff;
drop role admin;

create user cust1 identified by oracle;
create user member1 identified by oracle;
create user staff1 identified by oracle;
create user admin1 identified by oracle;

create role customer;
create role membership;
create role staff;
create role admin;

grant customer to cust1;
grant membership to member1;
grant staff to staff1;
grant admin to admin1;

grant select on book to customer, membership;
grant select on branch to customer, membership;
grant select on all_tables to staff;
grant all privileges to admin;
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
   book_description  varchar2(200),
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
CONSTRAINT staff_id_fk foreign key (staff_id) references employee(employee_id),
CONSTRAINT employee_manger_fk foreign key (employee_manger) references employee(employee_id)
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
   book_code  varchar2(10) NULL,
   package_id  varchar2(10) NULL,
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


insert into customer values ('C001','Kenny Tan','Male','Taman Permai, 31400 Ipoh, Perak','kenny@gmail.com','15-Aug-95');
insert into customer values ('C002','Ahmad Hafiz','Male','Taman Kaya, 32000 Kuala Lumpur','ahmad@hotmail.com','30-Jul-99');
insert into customer values ('C003','Beng Soon Tian','Male','Taman Perpaduan, 51900 Johor Bahru, Johor','ahbeng@gmail.com','27-May-00');
insert into customer values ('C004','Isabella Tan','Female','Taman Ipoh, 33400 Ipoh, Perak','Isabella@yahoo.com','10-Aug-93');
insert into customer values ('C005','Megan Fox','Female','Taman Lingau, 11900 Bayan Lepas, Pulau Pinang','meganfox@gmail.com','20-Feb-93');
insert into customer values ('C006','Mohammad Ali','Male','Taman Cenggal, 31910 Kampar, Perak','mohammad@gmail.com','27-Apr-00');
insert into customer values ('C007','Alicia Tan','Female','Taman Emas, 31300 Ipoh, Perak','alicia@yahoo.com','11-Jan-93');
insert into customer values ('C008','Yvonne Cheah','Female','Taman Selangor, 40100 Shah Alam, Selangor','yvone@hotmail.com','25-Apr-93');

insert into membership values ('NORM001', 'C001', 0.10, '20-Jun-22', '20-May-20', 'Kenny1801', 'xnbxx19011', 30);
insert into membership values ('NORM002', 'C002', 0.10, '19-May-21', '20-May-20', 'ahmad9407', 'caweg15121', 20);
insert into membership values ('NORM003', 'C003', 0.10, '10-Jul-22', '11-Jul-20', 'ahbeng8932', 'beng98213', 40);
insert into membership values ('VIP001', 'C004', 0.10, '10-May-21', '20-May-20', 'isabel2812', 'isatan74352', 50);
insert into membership values ('VIP002', 'C005', 0.10, '8-Oct-22', '9-Oct-21', 'megan5723', 'fox92351', 60);

insert into normal_member values ('NORM001', 0.10);
insert into normal_member values ('NORM002', 0.10);
insert into normal_member values ('NORM003', 0.10);

insert into vip_member values ('VIP001', 0.10);
insert into vip_member values ('VIP002', 0.10);

insert into membership_package values ('PK001', 12, 0.10, 80.00);
insert into membership_package values ('PK002', 10, 0.10, 70.00);
insert into membership_package values ('PK003', 6, 0.10, 50.00);
insert into membership_package values ('PK004', 13, 0.10, 85.00);
insert into membership_package values ('PK005', 24, 0.10, 160.00);

insert into book values ('9780525541','Such A Fun Age',50.99,'A story which explores the way race, class, and even well-meaning gestures can have real impact on people''s lives.','English','Kiley Reid','G.P. Putnam''s Sons');
insert into book values ('0385544251','Harry Potter and the Sorcerer''s Stone',70.99,'IA mysterious visitor rescues Harry Potter from his relatives and takes him to his new home, Hogwarts School of Witchcraft and Wizardry.','English','J.K. Rowling','Scholastic Inc');
insert into book values ('0143136666','The Comfort Book',50.99,'A small book for anyone in search of hope, looking for a path to a more meaningful life, or in need of encouragement.','English','Matt Haig','Penguin Life');
insert into book values ('1984881787','Letters to a Young Athlete',60.50,'Chris Bosh fell in love with basketball at an early age and earned the prestigious “Mr. Basketball” title while still in high school in Dallas, Texas.','English','Chris Bosh','G.P. Putnam''s Sons');
insert into book values ('8175157526','An Introduction to Database Systems',120.00,'This text is designed to teach the concepts of database systems, from the basic to the relatively sophisticated.','English','Desai Bipin C','Galgotia Publications Pvt Ltd');
insert into book values ('0525457585','Harry Potter and the Chamber of Secrets',70.99,'Ever since Harry Potter had come home for the summer, the Dursleys had been so mean and hideous that all Harry wanted was to get back to the Hogwarts School for Witchcraft and Wizardry.','English','J.K. Rowling','Arthur A. Levine Books');
insert into book values ('0143039954','The Odyssey',39.90,'If the Iliad is the world''s greatest war epic, then the Odyssey is literature''s grandest evocation of everyman''s journey though life.','English','Robert Fagles','Penguin Classics');
insert into book values ('0141026294','Odysseus Returns Home',39.90,'After ten years at war and ten years wandering the world, Odysseus has finally returned home. But he cannot reveal his identity to his faithful wife Penelope.','English','Robert Eagles','Penguin Books');
insert into book values ('1501118811','House of Sticks',50.90,'An intimate beautifully written coming-of-age memoir recounting young girl''s journey from war-torn Vietnam to Ridgewood, Queens, her struggle to find her voice amid clashing cultural expectations.','English','Ly Tran','Scribner');
insert into book values ('0470624701','Fundamentals of Database Management Systems',150.00,'This lean, focused text concentrates on giving students a clear understanding of database fundamentals while providing a broad survey of all the major topics of the field.','English','Mark L. Gillenson','Galgotia Publications Pvt Ltd');

insert into category values ('C01','Fiction');
insert into category values ('C02','Fiction HP');
insert into category values ('C03','Non-Fiction');
insert into category values ('C04','Non-Fiction Odyssey');
insert into category values ('C05','History');
insert into category values ('C06','Reference Book Database');
insert into category values ('C07','Reference Book Maths');
insert into category values ('C08','Reference Book Science');
insert into category values ('C09','Magazine');
insert into category values ('C10','Horror');

insert into has_category values ('9780525541','C01');
insert into has_category values ('0385544251','C02');
insert into has_category values ('0143136666','C09');
insert into has_category values ('1984881787','C03');
insert into has_category values ('8175157526','C06');
insert into has_category values ('0525457585','C02');
insert into has_category values ('0143039954','C04');
insert into has_category values ('0141026294','C04');
insert into has_category values ('1501118811','C03');
insert into has_category values ('0470624701','C03');

insert into reference_book values ('C06','Database','Degree level');
insert into reference_book values ('C07','Maths','Secondary school level');
insert into reference_book values ('C08','Science','Secondary school level');

insert into fiction values ('C02','Harry Potter');

insert into non_fiction values ('C04','Odyssey');

insert into branch values ('BR01','1, Jalan EW, 40100, Shah Alam, Selangor','EW Downtown Bookstore','9am','8pm');
insert into branch values ('BR02','4, Jalan NS, 31910, Kampar, Perak','NS Downtown Bookstore','9am','8pm');
insert into branch values ('BR03','20, Jalan MM, 75200, Melaka','MM Downtown Bookstore','9am','8pm');
insert into branch values ('BR04','10, Jalan SAW, 11900, Bayan Lepas, Pulau Pinang','SAW Downtown Bookstore','9am','8pm');
insert into branch values ('BR05','16, Jalan JS, 51900, Johor Bahru, Johor','JS Downtown Bookstore','9am','8pm');

insert into book_branch values ('9780525541','BR01','15');
insert into book_branch values ('9780525541','BR02','8');
insert into book_branch values ('9780525541','BR03','3');
insert into book_branch values ('9780525541','BR04','12');
insert into book_branch values ('9780525541','BR05','10');
insert into book_branch values ('0385544251','BR01','3');
insert into book_branch values ('0385544251','BR02','10');
insert into book_branch values ('0385544251','BR03','10');
insert into book_branch values ('0385544251','BR04','10');
insert into book_branch values ('0385544251','BR05','7');
insert into book_branch values ('0143136666','BR01','4');
insert into book_branch values ('0143136666','BR02','8');
insert into book_branch values ('0143136666','BR03','10');
insert into book_branch values ('0143136666','BR04','16');
insert into book_branch values ('0143136666','BR05','14');
insert into book_branch values ('1984881787','BR01','5');
insert into book_branch values ('1984881787','BR02','5');
insert into book_branch values ('1984881787','BR03','3');
insert into book_branch values ('1984881787','BR04','6');
insert into book_branch values ('1984881787','BR05','10');
insert into book_branch values ('8175157526','BR01','1');
insert into book_branch values ('8175157526','BR02','9');
insert into book_branch values ('8175157526','BR03','12');
insert into book_branch values ('8175157526','BR04','3');
insert into book_branch values ('8175157526','BR05','3');
insert into book_branch values ('0525457585','BR01','5');
insert into book_branch values ('0525457585','BR02','9');
insert into book_branch values ('0525457585','BR03','6');
insert into book_branch values ('0525457585','BR04','10');
insert into book_branch values ('0525457585','BR05','2');
insert into book_branch values ('0143039954','BR01','3');
insert into book_branch values ('0143039954','BR02','6');
insert into book_branch values ('0143039954','BR03','6');
insert into book_branch values ('0143039954','BR04','5');
insert into book_branch values ('0143039954','BR05','11');
insert into book_branch values ('0141026294','BR01','6');
insert into book_branch values ('0141026294','BR02','8');
insert into book_branch values ('0141026294','BR03','8');
insert into book_branch values ('0141026294','BR04','9');
insert into book_branch values ('0141026294','BR05','4');
insert into book_branch values ('1501118811','BR01','6');
insert into book_branch values ('1501118811','BR02','5');
insert into book_branch values ('1501118811','BR03','5');
insert into book_branch values ('1501118811','BR04','10');
insert into book_branch values ('1501118811','BR05','3');
insert into book_branch values ('0470624701','BR01','3');
insert into book_branch values ('0470624701','BR02','8');
insert into book_branch values ('0470624701','BR03','10');
insert into book_branch values ('0470624701','BR04','2');
insert into book_branch values ('0470624701','BR05','7');

insert into levels values('L01','Top Management Finance');
insert into levels values('L02','Top Management Normal');
insert into levels values('L03','Admin Finance');
insert into levels values('L04','Admin Normal');
insert into levels values('L05','Normal Staff');

insert into admin values('L01','top111','111top');
insert into admin values('L03','admin113','113admin');

insert into designation values('D01','Financial Controller','L01');
insert into designation values('D02','Manager','L02');
insert into designation values('D03','Senior Executive','L04');
insert into designation values('D04','Accountant','L03');
insert into designation values('D05','Secretary','L04');
insert into designation values('D06','Customer Service BR1','L05');
insert into designation values('D07','Customer Service BR2','L05');
insert into designation values('D08','Customer Service BR3','L05');
insert into designation values('D09','Customer Service BR4','L05');
insert into designation values('D10','Customer Service BR5','L05');
insert into designation values('D11','Sales Personnel BR1','L04');
insert into designation values('D12','Sales Personnel BR2','L04');
insert into designation values('D13','Sales Personnel BR3','L04');
insert into designation values('D14','Sales Personnel BR4','L04');
insert into designation values('D15','Sales Personnel BR5','L04');
insert into designation values('D16','Van Driver BR1','L05');
insert into designation values('D17','Van Driver BR2','L05');
insert into designation values('D18','Van Driver BR3','L05');
insert into designation values('D19','Van Driver BR4','L05');
insert into designation values('D20','Van Driver BR5','L05');

insert into customer_service values('D06','032222666','BR01');
insert into customer_service values('D07','052222777','BR02');
insert into customer_service values('D08','062222888','BR03');
insert into customer_service values('D09','042222999','BR04');
insert into customer_service values('D10','072222100','BR05');

insert into sales_personnel values('D11','12803','640');
insert into sales_personnel values('D12','25000','1250');
insert into sales_personnel values('D13','5000','0');
insert into sales_personnel values('D14','38593.80','1929.69');
insert into sales_personnel values('D15','9771.30','488.57');

insert into van_driver values('D16','BBC5881','5','Allowed');
insert into van_driver values('D17','ASD1661','0',' Not Allowed');
insert into van_driver values('D18','MWM3226','2','Allowed');
insert into van_driver values('D19','PPP4210','3.5','Allowed');
insert into van_driver values('D20','JHR1485','1.8','Allowed');

insert into employee values('E001','Eazin Poe','Male','0164201994',to_date('1994-04-20', 'yyyy-mm-dd'),'11500','D01','BR03');
insert into employee values('E002','Stefan Guo','Male','014109679',to_date('1994-04-10', 'yyyy-mm-dd'),'5000','D02','BR01');
insert into employee values('E003','Vera Tiff','Female','0165587785',to_date('1997-06-11', 'yyyy-mm-dd'),'5000','D02','BR02');
insert into employee values('E004','Rosoria Wang','Female','0171231234',to_date('1988-03-23', 'yyyy-mm-dd'),'2000','D11','BR01');
insert into employee values('E005','Qi Si Jun','Male','0176556710',to_date('1993-10-14', 'yyyy-mm-dd'), '2000', 'D12','BR02');
insert into employee values('E006','Luo Yat Zhou','Female','0151234321',to_date('1980-08-31', 'yyyy-mm-dd'),'2000','D13','BR03');	
insert into employee values('E007','Lee Zi Jia','Male','0111235678',to_date('1981-10-10', 'yyyy-mm-dd'),'2000','D14','BR04');
insert into employee values('E008','Byun Baek Hyun','Male','0175467765',to_date('1999-10-11', 'yyyy-mm-dd'),'2000','D15','BR05');
insert into employee values('E009','Jermaine Wayle','Female','0168764328',to_date('1993-11-25', 'yyyy-mm-dd'),'4200','D04','BR04');
insert into employee values('E010','Tang Min Yew','Female','0181228888',to_date('1993-01-13', 'yyyy-mm-dd'),'800','D06','BR01');
insert into employee values('E011','Heng Er Jie','Male','0130908897',to_date('1988-11-12', 'yyyy-mm-dd'),'1400','D07','BR02');
insert into employee values('E012','Anicia Tang','Female','015673498',to_date('1997-12-13', 'yyyy-mm-dd'),'1000','D08','BR03');
insert into employee values('E013','Lu Ban','Male','0117048638',to_date('1996-09-27', 'yyyy-mm-dd'),'1400','D09','BR04');
insert into employee values('E014','Matthew Brandon','Male','0196962794',to_date('1985-09-30', 'yyyy-mm-dd'),'1400','D10','BR05');
insert into employee values('E015','Jermaine Wayle','Female','0107335674',to_date('1984-02-05', 'yyyy-mm-dd'),'3200','D05','BR05');
insert into employee values('E016','Hamad Asin','Male','0198899899',to_date('1981-05-04', 'yyyy-mm-dd'),'1500','D16','BR01');
insert into employee values('E017','Jarod Edwin','Male','0101100110',to_date('1979-09-27', 'yyyy-mm-dd'),'1200','D17','BR02');
insert into employee values('E018','Yew Mee Yiu','Female','0123737337',to_date('1977-10-26', 'yyyy-mm-dd'),'1100','D18','BR03');
insert into employee values('E019','Cham Que Tiew','Male','0114362345',to_date('1975-01-05', 'yyyy-mm-dd'),'750','D19','BR04');
insert into employee values('E020','Sabrini Ninina','Female','0138598898',to_date('1977-03-11', 'yyyy-mm-dd'),'1500','D20','BR05');

insert into manager values('E002','1100');
insert into manager values('E003','2100');

insert into staff values('E004','E003');
insert into staff values('E005','E003');
insert into staff values('E006','E003');
insert into staff values('E007','E003');
insert into staff values('E008','E003');
insert into staff values('E010','E002');
insert into staff values('E011','E002');
insert into staff values('E012','E002');
insert into staff values('E013','E002');
insert into staff values('E014','E002');
insert into staff values('E015','E002');
insert into staff values('E016','E003');
insert into staff values('E017','E003');
insert into staff values('E018','E003');
insert into staff values('E019','E003');
insert into staff values('E020','E003');

insert into top_management values('E001',to_date('2021-08-18', 'yyyy-mm-dd'),'5pm','Room 6 Branch Melaka');

insert into payment values ('P001', 'E004', 'C001', '15-May-21',  TO_CHAR(TO_DATE('1730', 'HH24MI'), 'HH24MI'), 'Cash', 67.35);
insert into payment values ('P002', 'E004', 'C001', '17-May-21', TO_CHAR(TO_DATE('1330', 'HH24MI'), 'HH24MI'), 'Cash', 31.10);
insert into payment values ('P003', 'E004', 'C002', '24-May-21', TO_CHAR(TO_DATE('1245', 'HH24MI'), 'HH24MI'), 'Credit Card', 70.65);
insert into payment values ('P004', 'E008', 'C002', '12-Jun-21', TO_CHAR(TO_DATE('1020', 'HH24MI'), 'HH24MI'), 'Credit Card', 103.20);
insert into payment values ('P005', 'E008', 'C003', '25-Jun-21', TO_CHAR(TO_DATE('1525', 'HH24MI'), 'HH24MI'), 'Cash', 40.20);
insert into payment values ('P006', 'E007', 'C003', '21-Aug-21', TO_CHAR(TO_DATE('1412', 'HH24MI'), 'HH24MI'), 'Cash', 35.75);
insert into payment values ('P007', 'E007', 'C004', '12-Jul-21', TO_CHAR(TO_DATE('1755', 'HH24MI'), 'HH24MI'), 'Credit Card', 140.10);
insert into payment values ('P008', 'E007', 'C004', '18-Apr-21', TO_CHAR(TO_DATE('1125', 'HH24MI'), 'HH24MI'), 'Credit Card', 85.65);
insert into payment values ('P009', 'E005', 'C005', '13-May-21', TO_CHAR(TO_DATE('1845', 'HH24MI'), 'HH24MI'), 'Cash', 56.85);
insert into payment values ('P010', 'E005', 'C006', '19-Apr-21', TO_CHAR(TO_DATE('1935', 'HH24MI'), 'HH24MI'), 'Credit Card', 76.25);
insert into payment values ('P011', 'E004', 'C007', '26-May-21', TO_CHAR(TO_DATE('1615', 'HH24MI'), 'HH24MI'), 'Cash', 50.55);
insert into payment values ('P012', 'E004', 'C008', '3-Jun-21', TO_CHAR(TO_DATE('1235', 'HH24MI'), 'HH24MI'), 'Credit Card', 66.70);
insert into payment values ('P013', 'E005', 'C008', '14-Aug-21', TO_CHAR(TO_DATE('1120', 'HH24MI'), 'HH24MI'), 'Cash', 66.70);
insert into payment values ('P014', 'E007', 'C008', '7-Aug-21', TO_CHAR(TO_DATE('1040', 'HH24MI'), 'HH24MI'), 'Credit Card', 66.70);
insert into payment values ('P015', 'E004', 'C008', '14-Aug-21', TO_CHAR(TO_DATE('1425', 'HH24MI'), 'HH24MI'), 'Cash', 66.70);
insert into payment values ('P016', 'E008', 'C008', '31-Aug-21', TO_CHAR(TO_DATE('1500', 'HH24MI'), 'HH24MI'), 'Credit Card', 66.70);
insert into payment values ('P017', 'E004', 'C008', '21-Aug-21', TO_CHAR(TO_DATE('1400', 'HH24MI'), 'HH24MI'), 'Cash', 66.70);
insert into payment values ('P018', 'E004', 'C008', '21-Aug-21', TO_CHAR(TO_DATE('1100', 'HH24MI'), 'HH24MI'), 'Credit Card', 66.70);
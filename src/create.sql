
create table CITY_STATE
(
  zipcode char(5) not null,
  city varchar2(30),
  state char(2),
  constraint cityPK primary key (zipcode)
);


create table PERSON
(
  ssn char(9) not null,
  fname varchar2(20) not null,
  minit char(1),
  lname varchar2(20) not null,
  sex char(1) check (sex in ('M', 'F')),
  dob date,
  street varchar2(30),
  zipcode char(5),
  phone char(10),
  constraint personPK primary key (ssn)
);


create table EMPLOYEE
(
  ssn char(9) not null,
  constraint empPK primary key (ssn),
  constraint emppersonFRK foreign key (ssn) references person(ssn) on delete cascade
);


create table DEPENDENT
(
  name varchar2(40) not null,
  essn char(9) not null,
  relationship varchar2(20),
  dob date,
  sex char(1) check (sex in ('M', 'F')),
  constraint dependentPK primary key (name, essn)
);


create table STUDENT
(
  ssn char(9) not null,
  student_no char(12) not null,
  degree_prog varchar2(3),
  minor_dept number(5,0),
  major_dept number(5,0) not null,
  class varchar2(20),
  constraint studentPK primary key (ssn),
  constraint personstuFRK foreign key (ssn) references person(ssn) on delete cascade,
  constraint stunumUK unique (student_no)
);


create table STAFF
(
  ssn char(9) not null,
  title varchar2(20),
  dno number(5,0),
  constraint staffPK primary key (ssn),
  constraint empstaffFRK foreign key (ssn) references employee(ssn) on delete cascade
);


create table FACULTY
(
  ssn char(9) not null,
  degree varchar2(10),
  rank varchar2(20),
  employment_type varchar2(9),
  constraint facultyPK primary key (ssn),
  constraint empfacultyFRK foreign key (ssn) references employee(ssn) on delete cascade
);


create table SALARY_SCALE 
(
  rank varchar2(20) not null,
  employment_type varchar2(9) not null,
  salary number(8,2),
  constraint salscalePK primary key (rank, employment_type)
);


create table GRAD_STUDENT
(
  student_ssn char(9) not null,
  advisor_ssn char(9) not null,
  constraint gradstudentPK primary key (student_ssn),
  constraint advisorFRK foreign key (advisor_ssn) references faculty(ssn) on delete set null,
  constraint gradstudentFRK foreign key (student_ssn) references student(ssn) on delete cascade
);


create table DEPARTMENT
(
  dno number(5,0) not null,
  dname varchar2(50) not null,
  college varchar2(50),
  office_no varchar2(5),
  chair_ssn char(9),
  constraint dnameUK unique (dname),
  constraint deptPK primary key (dno),
  constraint deptchairFRK foreign key (chair_ssn) references staff(ssn) on delete set null
);


create table OFFICE
(
  office_no varchar2(5) not null,
  office_ph char(10),
  constraint officenoPK primary key (office_no)
);


create table APPOINTED_TO
(
  fssn char(9) not null,
  dno number(5,0) not null,
  constraint appointedPK primary key (fssn, dno),
  constraint appfssnFRK foreign key (fssn) references faculty(ssn) on delete cascade,
  constraint appdnoFRK foreign key (dno) references department(dno) on delete cascade
);


create table COURSE
(
  cno varchar2(10) not null,
  cname varchar2(50),
  credits number(5,0),
  dno number(5,0),
  constraint coursePK primary key (cno),
  constraint coursednoFRK foreign key (dno) references department(dno) on delete cascade
);


create table COURSE_PREREQUISITE
(
  cno varchar2(10) not null,
  prerequisite_cno varchar2(10) not null,
  constraint courseprereqPK primary key (cno, prerequisite_cno),
  constraint cno1FRK foreign key (cno) references course(cno) on delete cascade,
  constraint cno2FRK foreign key (prerequisite_cno) references course(cno) on delete cascade
);


create table STUDY_PLAN
(
  student_ssn char(9) not null,
  cno varchar2(10) not null,
  constraint studyplanPK primary key (student_ssn, cno),
  constraint spstuFRK foreign key (student_ssn) references student(ssn) on delete cascade,
  constraint spcnoFRK foreign key (cno) references course(cno) on delete cascade
);


create table TRANSCRIPT
(
  student_ssn char(9) not null,
  cno varchar2(10) not null,
  grade varchar2(2) not null,
  constraint transcriptPK primary key (student_ssn, cno),
  constraint tstuFRK foreign key (student_ssn) references student(ssn) on delete cascade,
  constraint tcnoFRK foreign key (cno) references course(cno) on delete cascade
);


create table SECTION
(
  sno number(5,0) not null,
  semester varchar2(6) not null,
  year number(5,0) not null,
  meeting_day varchar2(9),
  meeting_time varchar2(7),
  meeting_room varchar2(5),
  instructor char(9),
  cno varchar2(10) not null,
  constraint sectionPK primary key (sno, semester, year, cno),
  constraint instructorFRK foreign key (instructor) references faculty(ssn) on delete cascade,
  constraint sectioncnoFRK foreign key (cno) references course(cno) on delete cascade
);


create table GRADE_REPORT
(
  student_ssn char(9) not null,
  sno number(5,0) not null,
  semester varchar2(6) not null,
  year number(4,0) not null,
  cno varchar2(10) not null,
  grade varchar2(2),
  constraint greportPK primary key (student_ssn, sno, semester, year, cno),
  constraint grssnFRK foreign key (student_ssn) references student(ssn) on delete cascade,
  constraint grsectionFRK foreign key (sno, semester, year, cno) references section(sno, semester, year, cno) on delete cascade
);




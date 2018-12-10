alter table PERSON add
(
  constraint zipcodeFRK foreign key (zipcode) references city_state(zipcode) on delete set null
);


alter table DEPENDENT add
(
  constraint deppersonFRK foreign key (essn) references employee(ssn) on delete cascade
);


alter table FACULTY add
(
  constraint salaryFRK foreign key (employment_type, rank) references salary_scale(employment_type, rank) on delete cascade
);


alter table DEPARTMENT add 
(
  constraint deptofficeFRK foreign key (office_no) references office(office_no) on delete set null
);


alter table STAFF add
(
  constraint staffdnoFRK foreign key (dno) references department(dno) on delete cascade
);


alter table STUDENT add
(
  constraint mindeptFRK foreign key (minor_dept) references department(dno) on delete set null,
  constraint majdeptFRK foreign key (major_dept) references department(dno) on delete cascade
);
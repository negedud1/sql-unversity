# University Database Design

Individual graduate course work; Designed and implemented a database for a university environment in ORACLE SQL*PLUS.

## Overview
This project involves the design and implementation of a database for a real miniworld environment based on the given database requirements written in natural languages.

The Project Report consists of:
1. A partition of the sentences (database requirement description in natural language) into homogeneous groups.
2. A design of the conceptual schema of the univeristy database through the use of an EER diagram and CSDL (Conceptual schema definition language).
3. Tranformation of the database EER schema into the corresponding relational database schema.
4. A list of all the join paths that exists within the relational database schema.
5. A normalized relation schema, to 3NF.

The SQL*PLUS statements that were written for the creation, insertion and querying of the database are:
* src/add_complex_constraints
* src/create.sql 
* src/inserton.sql 
* src/queries.sql


## Database Requirements
In a university, we represent data about both students and employees. The university keeps track of each student's name, student number, social security number, address, phone, birth date, sex, class (freshman, sophomore,..., graduate), major department, minor department (if any), and degree program (B.A., B.S., M.A., M.S., ..., Ph.D.). Some user applications need to access the city, state, and zip code of the student's address and the student last name. Both social security number and student number have unique values for each student. Each student has a study plan that shows list of required courses to be taken.

Each department is described by a name, department number, office number, office phone, and college. Both department name and department number have unique values for each department. Each department has a Chairperson or a Dean in charge of that department. Each course has a course name, course number, number of semester hours (credit), and offering department. Some courses have prerequisites (please pay attention here). Each course has the day, meeting time, place where the class is held. Each section has an instructor, semester, year, course, and section number. The section number distinguishes different sections of the same course that is taught during the same semester/year (may be at the same time), its values are 1, 2, 3, ..., up to the number of sections taught during each semester. Employees are classified into faculty and staff, both of them have dependents, the database stores the information of employees' dependents for the insurance and benefit purposes.

Faculty could be full-time or part-time employees. Professors have ranks (Lecturer, Assistant Professor, Associate Professor, Full Professor) and salaries. Faculties (Professors) may hold different degree (highest degree is only considered here). Each professor belongs to at least one department. Professors may have joint appointments from other department(s).

Staff are secretaries, program coordinators, assistant directors, directors, deans, vice presidents, and president.

A grade report for a class has a student name, section number, and grades. Students may have a transcript for all the courses they have taken. For graduate students, the student’s advisor should be included in the database.


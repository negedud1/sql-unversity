-- 1. For each department, list the numbers of major students and minor students.
select dname, count(*)
from department
left join student 
on dno = major_dept or dno = minor_dept
group by dname;


-- 2. For each department, list all the instructors along with the number of courses he/she teaches.
select d.dname, a.fssn as ssn, count(s.sno) as num_of_courses
from department d
left join appointed_to a 
on d.dno = a.dno
left join section s
on a.fssn = s.instructor
group by d.dname, a.fssn
order by d.dname asc;


-- 3. For each department, list all the courses which it offers.
select d.dname, c.cno
from department d
left join course c 
on d.dno = c.dno
group by d.dname, c.cno
order by d.dname asc;


-- 4. For each course, list all the prerequisites of that course.
select c.cno, p.prerequisite_cno
from course c
left join course_prerequisite p
on c.cno = p.cno
group by c.cno, p.prerequisite_cno
order by c.cno asc;


-- 5. For each department, list the total number of professors and average teaching load.
select d.dname, count(distinct t1.fssn) as prof_ct, count(load)/count(distinct t1.fssn) as avg_load
from department d
    left join 
    (select dno, fssn from appointed_to) t1
    on t1.dno = d.dno
    left join
    (select count(*) as load, instructor from section group by instructor) t2
    on t1.fssn = t2.instructor
group by d.dname;


-- 6. For each department, list the total numbers of students, total number of credit hours taken by these students, and the average credit hour per student.
select d.dname, count(distinct t1.ssn) as stu_ct, sum(t2.credits) as tl_cr, sum(t2.credits) / count(distinct t1.ssn) as avg_cr
from department d,
      (select ssn, major_dept, minor_dept from student) t1,
      (select c.credits, t.student_ssn as ssn from transcript t, course c where t.cno = c.cno) t2
where (t1.major_dept = d.dno or t1.minor_dept = d.dno) and (t2.ssn = t1.ssn)
group by d.dname;


-- 7. For each instructor, list the number of all students who register in the sections that the instructor teaches.
select f.ssn, stu.student_no
from faculty f
left join section s
on f.ssn = s.instructor
left join grade_report g
on s.sno = g.sno and s.semester = g.semester and s.year = g.year and s.cno = g.cno
left join student stu
on stu.ssn = student_ssn
group by f.ssn, stu.student_no
order by f.ssn asc;


-- 8. For each instructor, list all the departments which offer the courses that the instructor teaches.
select f.ssn, d.dname
from faculty f
left join department d
on exists ((select cno from course where dno = d.dno) intersect (select cno from section where instructor = f.ssn))
group by f.ssn, d.dname
order by f.ssn asc;


-- 9. For each department, list all the professors who teach more than two courses, and make the salaries less than the average salary of the professors in their department.
select d.dname, f.ssn
from department d 
left join appointed_to a 
on d.dno = a.dno
left join faculty f
on a.fssn = f.ssn
left join salary_scale ss
on f.rank = ss.rank and f.employment_type = ss.employment_type
where (select count(*) from section where instructor = f.ssn) > 2 
and ss.salary < (select avg(sal.salary) 
                from faculty fac, salary_scale sal, appointed_to at 
                where fac.rank = sal.rank and fac.employment_type = sal.employment_type and at.fssn = fac.ssn and at.dno = d.dno)
group by d.dname, f.ssn;


-- 10. Show how many students that each professor advises.
select ssn, count(student_ssn)
from faculty
left join grad_student
on ssn = advisor_ssn
group by ssn;


-- 11. Find the departments which have more students than the average students per department.
select dname, count(*)
from department
inner join student 
on dno = major_dept or dno = minor_dept
group by dname
having count(*) > (select avg(count)
                   from (select count(*) as count
                        from department
                        inner join student 
                        on dno = major_dept or dno = minor_dept
                        group by dno));


-- 12. Find the departments whose total salary is greater than the average salary per department.
select d.dname, sum(s.salary) as avg_salary
from department d 
inner join appointed_to a 
on d.dno = a.dno
inner join faculty f 
on a.fssn = f.ssn 
inner join salary_scale s
on f.rank = s.rank and f.employment_type = s.employment_type
group by d.dname
having sum(s.salary) > (select avg(avg_salary)
                        from (select d.dname, sum(s.salary) as avg_salary
                              from department d 
                              inner join appointed_to a 
                              on d.dno = a.dno
                              inner join faculty f 
                              on a.fssn = f.ssn 
                              inner join salary_scale s
                              on f.rank = s.rank and f.employment_type = s.employment_type
                              group by d.dname));


-- 13. Foreach department,list the professors who have the number of Ph.D. student she/she advises more than the average number of Ph.D. students these professors advise in their department.
select d.dname, a.fssn, count(g.advisor_ssn) as count
from department d 
left join appointed_to a 
on d.dno = a.dno
inner join (grad_student g 
inner join student s 
on g.student_ssn = s.ssn and s.degree_prog = 'PHD')
on a.fssn = g.advisor_ssn
group by d.dname, a.fssn, d.dno
having count(g.advisor_ssn) > (select avg(phd_count)
                                from (select count(*) as phd_count
                                      from appointed_to at, grad_student gs, student stu 
                                      where at.dno = d.dno 
                                        and at.fssn = gs.advisor_ssn 
                                        and gs.student_ssn = stu.ssn 
                                        and stu.degree_prog = 'PHD'))
order by d.dname asc;


-- 14. List the students who have completed all the prerequisite courses for their major.
select s.ssn
from student s
where not exists
      ((select distinct c.cno
        from course c, course_prerequisite p
        where c.dno = s.major_dept and c.cno = p.prerequisite_cno)
        minus
        (select cno from transcript where student_ssn = s.ssn));


-- 15. List the students who have taken all the courses offered by Professor Smith.
select stu.ssn 
from student stu 
where not exists
      ((select s.cno
        from person p, section s 
        where p.ssn = s.instructor and p.lname = 'Smith')
        minus
        (select cno from transcript where student_ssn = stu.ssn));


-- 16. List the students who have only taken the courses taught by Professor Smith.

select distinct stu.ssn
from student stu, transcript t 
where stu.ssn = t.student_ssn and not exists
                                  ((select cno from transcript where student_ssn = stu.ssn)
                                    minus
                                    (select s.cno
                                    from person p, section s 
                                    where p.ssn = s.instructor and p.lname = 'Smith'));


-- 17. List the students who have taken all the courses that the student Franklin has taken.
select stu.ssn 
from student stu 
where not exists ((select t.cno 
                  from person p, transcript t
                  where p.ssn = t.student_ssn and p.fname = 'Franklin')
                  minus 
                  (select cno from transcript where student_ssn = stu.ssn));


-- 18. List the students who passed all the exams required by their respective study plan.
select stu.ssn 
from student stu
where not exists ((select cno
                  from study_plan
                  where student_ssn = stu.ssn)
                  minus
                  (select cno from transcript where student_ssn = stu.ssn and grade in ('A', 'A-', 'B+', 'B', 'B-', 'C+')));

        
-- 19. List the students who had taken the courses required by their study plan.
select stu.ssn 
from student stu
where not exists ((select cno
                  from study_plan
                  where student_ssn = stu.ssn)
                  minus
                  (select cno from transcript where student_ssn = stu.ssn));






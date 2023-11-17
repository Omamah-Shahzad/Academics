Create Database lab05;
Use lab05;
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor VARCHAR(100)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Students (student_id, first_name, last_name, date_of_birth)
VALUES
    (1, 'John', 'Doe', '1995-05-15'),
    (2, 'Jane', 'Smith', '1998-09-20'),
    (3, 'Alice', 'Johnson', '1997-03-13'),
    (4, 'Ella', 'Johnson', '1996-07-12'),
    (5, 'Liam', 'Brown', '1999-02-25'),
    (6, 'Ava', 'Miller', '1998-11-18'),
    (7, 'Noah', 'Garcia', '1997-09-03'),
    (8, 'Olivia', 'Martinez', '1996-04-29'),
    (9, 'Emma', 'Lopez', '1998-06-21'),
    (10, 'William', 'Davis', '1997-03-14'),
    (11, 'Sophia', 'Rodriguez', '1999-08-05'),
    (12, 'James', 'Hernandez', '1995-12-08'),
    (13, 'Charlotte', 'Young', '1996-10-17'),
    (14, 'Benjamin', 'Lee', '1998-05-20'),
    (15, 'Amelia', 'Walker', '1997-01-23');

INSERT INTO Courses (course_id, course_name, instructor)
VALUES
    (101, 'Introduction to Database', 'Professor Smith'),
    (102, 'Web Development Basics', 'Professor Johnson'),
    (103, 'Data Analysis Techniques', 'Professor Brown'),
    (104, 'Advanced Database Management', 'Professor Johnson'),
    (105, 'Data Mining Techniques', 'Professor Lee'),
    (106, 'Web Application Development', 'Professor Martinez'),
    (107, 'Software Engineering Principles', 'Professor Davis'),
    (108, 'Network Security Fundamentals', 'Professor Rodriguez'),
    (109, 'Artificial Intelligence Fundamentals', 'Professor Hernandez'),
    (110, 'Database Design and Optimization', 'Professor Young'),
    (111, 'Mobile App Development', 'Professor Walker'),
    (112, 'Cloud Computing Technologies', 'Professor Moore'),
    (113, 'Human-Computer Interaction', 'Professor Turner'),
    (114, 'Business Analytics', 'Professor Perez'),
    (115, 'Computer Graphics and Visualization', 'Professor Foster');


INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES
    (1, 1, 101, '2023-01-15'),
    (2, 1, 102, '2023-02-20'),
    (3, 2, 101, '2023-01-15'),
    (4, 3, 103, '2023-03-05'),
    (5, 4, 104, '2023-02-10'),
    (6, 5, 105, '2023-03-15'),
    (7, 6, 106, '2023-01-22'),
    (8, 7, 107, '2023-04-05'),
    (9, 8, 108, '2023-02-28'),
    (10, 10, 109, '2023-01-10'),
    (11, 10, 110, '2023-03-18'),
    (12, 11, 112, '2023-02-08'),
    (13, 12, 112, '2023-03-02'),
    (14, 13, 113, '2023-04-12'),
    (15, 14, 114, '2023-01-29'),
    (16, 15, 115, '2023-03-21');

-----Q01-----
Create View [StudentList]
AS
SELECT student_id, first_name + ' ' +last_name AS name, date_of_birth
FROM Students

SELECT *
FROM StudentList

-----Q02-----
SELECT TOP 5 *
FROM StudentList

-----Q03-----
ALTER VIEW [StudentList]
AS
SELECT student_id, first_name + ' ' +last_name AS name, date_of_birth, DATEDIFF(Year, date_of_birth, GETDATE()) AS age
FROM Students

SELECT *
FROM StudentList

-----Q04-----
Create View [CourseEnrollments]
AS
SELECT c.course_id, c.course_name, COUNT(e.student_id) AS NoOfStudents
FROM Courses c
JOIN Enrollments e 
ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name

SELECT *
FROM CourseEnrollments

-----Q05-----
SELECT course_id, course_name
FROM CourseEnrollments
WHERE NoOfStudents = (
	SELECT MAX(NoOfStudents)
	FROM CourseEnrollments
)

-----Q06-----
Alter View [CourseEnrollments]
AS
SELECT c.course_id, c.course_name, MAX(c.instructor) AS instructor, COUNT(e.student_id) AS NoOfStudents
FROM Courses c
JOIN Enrollments e 
ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name

SELECT *
FROM CourseEnrollments

-----Q07-----
SELECT sl.student_id, sl.name
FROM StudentList sl
JOIN Enrollments e
ON e.student_id = sl.student_id
JOIN CourseEnrollments ce
ON ce.course_id = e.course_id
WHERE NoOfStudents = (
	SELECT MAX(NoOfStudents)
	FROM CourseEnrollments
)

-----Q08-----
Drop View StudentList
Drop View CourseEnrollments

-----Q09-----
Create View [StudentCourseCount]
AS
SELECT s.student_id, s.first_name + ' ' +s.last_name AS name, COUNT(e.student_id) AS NoOfCourses
FROM Students s
JOIN Enrollments e
ON e.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name

SELECT *
FROM StudentCourseCount

-----Q10-----
SELECT *
FROM StudentCourseCount
WHERE NoOfCourses = (
	SELECT MAX(NoOfCourses)
	FROM StudentCourseCount
)

-----Q11-----
Create View [InstructorCourseCount]
AS
SELECT instructor, COUNT(course_id) AS NoOfCourses
FROM Courses
GROUP BY instructor

SELECT *
FROM InstructorCourseCount

-----Q12-----
SELECT *
FROM InstructorCourseCount
WHERE NoOfCourses = (
	SELECT MAX(NoOfCourses)
	FROM InstructorCourseCount
)

-----Q13-----
Create View [StudentEnrollments]
AS
SELECT s.student_id, s.first_name + ' ' +s.last_name AS name, STRING_AGG(c.course_name, ', ') AS ListOfCourses
FROM Students s
JOIN Enrollments e
ON e.student_id = s.student_id
JOIN Courses c
ON c.course_id = e.course_id
GROUP BY s.student_id, s.first_name, s.last_name

SELECT *
FROM StudentEnrollments

-----Q14-----
SELECT scc.student_id, scc.name, scc.NoOfCourses, c.course_name, icc.instructor
FROM StudentCourseCount scc
JOIN StudentEnrollments se
ON se.student_id = scc.student_id
JOIN Courses c
ON CHARINDEX(c.course_name, se.ListOfCourses)>0
JOIN InstructorCourseCount icc
ON icc.instructor = c.instructor
WHERE scc.NoOfCourses = (
	SELECT MAX(NoOfCourses)
	FROM StudentCourseCount
)

-----Q15-----
Create View [StudentCourseInfo]
AS
SELECT s.student_id, s.first_name + ' ' +s.last_name AS name, c.course_name, c.instructor
FROM Students s
JOIN Enrollments e
ON e.student_id = s.student_id
JOIN Courses c
ON c.course_id = e.course_id
GROUP BY s.student_id, s.first_name, s.last_name, c.course_name, c.instructor

SELECT *
FROM StudentCourseInfo
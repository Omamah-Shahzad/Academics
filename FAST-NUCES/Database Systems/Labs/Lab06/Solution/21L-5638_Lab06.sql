Create Database lab06;
Use lab06;
-------------------------------------------------------
-------------------STORED PROCEDURES-------------------
-------------------------LAB06-------------------------
-------------------------------------------------------
CREATE TABLE Students (
  studentID INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(50),
  age INT,
  rollNo VARCHAR(50),
  major VARCHAR(50)
);

-- Create the Courses table
CREATE TABLE Courses (
  courseID INT IDENTITY(1,1) PRIMARY KEY ,
  courseName VARCHAR(50),
  instructor VARCHAR(50),
  department VARCHAR(50),
  creditHour INT
);

-- Create the Enrollments table
CREATE TABLE Enrollments (
  enrollmentID INT IDENTITY(1,1) PRIMARY KEY ,
  studentID INT,
  courseID INT,
  FOREIGN KEY (studentID) REFERENCES Students(studentID),
  FOREIGN KEY (courseID) REFERENCES Courses(courseID)
);

-- Create the Grades table
CREATE TABLE Grades (
  gradeID INT IDENTITY(1,1) PRIMARY KEY ,
  enrollmentID INT,
  grade DECIMAL(4,2),
  FOREIGN KEY (enrollmentID) REFERENCES Enrollments(enrollmentID)
);

-- Inserting records into the Students table
INSERT INTO Students (name, age, rollNo, major) VALUES ('Giselle Collette', 20, 'l201234', 'Computer Science');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Emily Davis', 22, 'l212342', 'Data Science');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Kaeya Alberich', 21, 'l203451', 'Mathematics');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Florence Nightingale', 23, 'l203452', 'Data Science');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Waver Velvet', 21, 'l224324', 'Data Science');
INSERT INTO Students (name, age, rollNo, major) VALUES ('Benedict Blue', 21, 'l214984', 'Computer Science');

-- Inserting records into the Courses table
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Database Systems', 'Prof. Smith', 'CS', 4);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Web Development', 'Prof. Jonathan', 'CS', 4);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Theory of Automata', 'Prof. Williams', 'CS', 3);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Machine Learning', 'Prof. Williams', 'CS', 3);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Discrete Structures', 'Prof. Horace', 'CS', 3);
INSERT INTO Courses (courseName, instructor, department, creditHour) VALUES ('Numeric Computing', 'Prof. Sarah', 'MTH', 3);

-- Inserting records into the Enrollments table
INSERT INTO Enrollments (studentID, courseID) VALUES (1, 1); 
INSERT INTO Enrollments (studentID, courseID) VALUES (2, 1); 
INSERT INTO Enrollments (studentID, courseID) VALUES (2, 2); 
INSERT INTO Enrollments (studentID, courseID) VALUES (3, 3); 
INSERT INTO Enrollments (studentID, courseID) VALUES (5, 4); 
INSERT INTO Enrollments (studentID, courseID) VALUES (5, 3); 
INSERT INTO Enrollments (studentID, courseID) VALUES (5, 6); 
INSERT INTO Enrollments (studentID, courseID) VALUES (6, 1); 

-- Inserting records into the Grades table
INSERT INTO Grades (enrollmentID, grade) VALUES (1, 3.3); 
INSERT INTO Grades (enrollmentID, grade) VALUES (2, 2.7); 
INSERT INTO Grades (enrollmentID, grade) VALUES (3, 2.3); 
INSERT INTO Grades (enrollmentID, grade) VALUES (4, 4); 
INSERT INTO Grades (enrollmentID, grade) VALUES (5, 3.3); 
INSERT INTO Grades (enrollmentID, grade) VALUES (6, 3.7); 
INSERT INTO Grades (enrollmentID, grade) VALUES (7, 3); 
INSERT INTO Grades (enrollmentID, grade) VALUES (8, 3.7); 

-----Q01-----
Create Procedure [getUnenrolledStudents]
AS
BEGIN
	SELECT s.studentID, s.name, s.age, s.rollNo, s.major
	FROM Students s
	LEFT JOIN Enrollments e
	ON e.studentID = s.studentID
	WHERE e.studentID IS NULL
END
GO

EXECUTE getUnenrolledStudents

-----Q02-----
Create Procedure [updateStudentAge]
@studentID INT,
@newAge INT
AS
BEGIN
	UPDATE Students
	SET age = @newAge
	WHERE studentID = @studentID
END
GO

DECLARE @ID INT = 1
DECLARE @Age INT = 25
EXECUTE updateStudentAge
@studentID = @ID,
@newAge = @Age

SELECT *
FROM Students

-----Q03-----
Create Procedure [deleteStudent]
@studentID INT
AS
BEGIN
	Alter Table Enrollments add constraint FK_CONSTRAINT FOREIGN KEY (studentID) REFERENCES Students(studentID) on delete cascade
	Alter Table Enrollments add constraint FK_CONSTRAINT1 FOREIGN KEY (courseID) REFERENCES Courses(courseID) on delete set NULL
	Alter Table Grades add constraint FK_CONSTRAINT2 FOREIGN KEY (enrollmentID) REFERENCES Enrollments(enrollmentID) on delete set NULL
	DELETE 
	FROM Students 
	WHERE studentID = @studentID
END
GO

DECLARE @ID INT = 1
EXECUTE deleteStudent
@studentID = @ID

SELECT *
FROM Students

SELECT *
FROM Enrollments

-----Q04-----
Create Procedure [getCourseStudents]
@courseID INT
AS
BEGIN
	SELECT s.studentID, s.name, s.major
	FROM Students s
	JOIN Enrollments e
	ON e.studentID = s.studentID
	WHERE e.courseID = @courseID
END
GO

DECLARE @cID INT = 1
EXECUTE getCourseStudents
@courseID = @cID

-----Q05-----
Create Procedure [getStudentInfo]
@studentID INT
AS
BEGIN
	SELECT s.studentID, s.name, s.age, s.rollNo, s.major, c.courseName, c.department
	FROM Students s
	JOIN Enrollments e
	ON e.studentID = s.studentID
	JOIN Courses c 
	ON c.courseID = e.courseID
	WHERE s.studentID = @studentID
END
GO

DECLARE @ID INT = 2
EXECUTE getStudentInfo
@studentID = @ID

-----Q06-----
Create Procedure [getMostPopularCourse]
@department VARCHAR(50) = 'CS'
AS
BEGIN
	SELECT TOP 1 WITH TIES c.courseID, c.courseName, c.instructor, COUNT(e.studentID) AS NumberOfStudentsEnrolled, STRING_AGG(s.name, ', ') As StudentNames
	FROM Courses c
	JOIN Enrollments e
	ON e.courseID = c.courseID
	JOIN Students s
	ON s.studentID = e.studentID
	WHERE c.department = @department 
	GROUP BY c.courseID, c.courseName, c.instructor
	ORDER BY NumberOfStudentsEnrolled DESC
END
GO

EXECUTE getMostPopularCourse

-----Q07-----
Create Procedure [calculateCourseGPA]
@courseID INT,
@averageGPA FLOAT OUTPUT
AS
BEGIN
	SELECT @averageGPA = AVG(g.grade)
	FROM Grades g
	JOIN Enrollments e
	ON e.enrollmentID = g.enrollmentID
	WHERE e.courseID = @courseID
END 
GO

DECLARE @ID INT = 1
DECLARE @AVG FLOAT
EXECUTE calculateCourseGPA
@courseID = @ID,
@averageGPA = @AVG OUTPUT
SELECT @AVG

-----Q08-----
Alter Procedure [calculateCourseGPA]
@averageGPA FLOAT OUTPUT
AS
BEGIN
	SELECT @averageGPA = AVG(grade)
	FROM Grades 
END
GO

DECLARE @AVG FLOAT
EXECUTE calculateCourseGPA
@averageGPA = @AVG OUTPUT
SELECT @AVG

-----Q09-----
Create Procedure [getCourseEnrollmentCount]
@courseID INT
AS
BEGIN
	SELECT courseID, COUNT(studentID) AS NumberOfStudentsEnrolled 
	FROM Enrollments
	WHERE courseID = @courseID
	GROUP BY courseID
END
GO

DECLARE @ID INT = 1
EXECUTE getCourseEnrollmentCount
@courseID = @ID

-----Q10-----
Create Procedure [getCourseWithoutGrades]
AS
BEGIN
	SELECT DISTINCT c.courseID, c.courseName, c.instructor, c.department, c.creditHour
	FROM Courses c
	JOIN Enrollments e
	ON e.courseID = c.courseID
	LEFT JOIN Grades g
	ON g.enrollmentID = e.enrollmentID
END
GO

EXECUTE getCourseWithoutGrades

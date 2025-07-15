/* =========================================================
   UNIVERSITY COMMUNITY SYSTEM - FULL BUILD & DEMO
   ========================================================= */
/* ---------- 0. Clean slate (safe for re-runs) ---------- */
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Teaching;
DROP TABLE IF EXISTS CourseTextbook;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS AcademicStaff;
DROP TABLE IF EXISTS GeneralStaff;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Textbook;

/* ---------- 1. Super-class ---------- */
CREATE TABLE Person
(
    person_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email     TEXT UNIQUE NOT NULL,
    phone     TEXT,
    hire_date DATE -- NULL for students
);

/* ---------- 2. Sub-classes ---------- */
CREATE TABLE Student (
    person_id INTEGER PRIMARY KEY,
    major     TEXT,
    year      INTEGER,          -- 1-4
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

CREATE TABLE AcademicStaff (
    person_id     INTEGER PRIMARY KEY,
    qualification TEXT,
    title         TEXT,
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

CREATE TABLE GeneralStaff (
    person_id INTEGER PRIMARY KEY,
    department TEXT,
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

/* ---------- 3. Courses & Textbooks ---------- */
CREATE TABLE Course (
    course_id  INTEGER PRIMARY KEY,
    code       TEXT UNIQUE,
    title      TEXT NOT NULL,
    credits    INTEGER
);

CREATE TABLE Textbook (
    isbn   TEXT PRIMARY KEY,
    title  TEXT NOT NULL,
    author TEXT
);

/* ---------- 4. Relationship tables ---------- */
CREATE TABLE Enrollment (
    person_id INTEGER,
    course_id INTEGER,
    PRIMARY KEY (person_id, course_id),
    FOREIGN KEY (person_id) REFERENCES Student(person_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Teaching (
    person_id INTEGER,
    course_id INTEGER,
    PRIMARY KEY (person_id, course_id),
    FOREIGN KEY (person_id) REFERENCES AcademicStaff(person_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE CourseTextbook (
    course_id INTEGER,
    isbn      TEXT,
    PRIMARY KEY (course_id, isbn),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (isbn) REFERENCES Textbook(isbn)
);

/* =========================================================
   SAMPLE DATA (5 students, 5 academic staff, 5 general staff,
                5 courses, 6 textbooks, plus joins)
   ========================================================= */

/* -- Students (and Person rows) -------------------------- */
INSERT INTO Person(person_id,full_name,email,phone,hire_date) VALUES
(1,'Aliya Mora','aliya@uni.ac.ke',NULL,NULL),
(2,'Brian Kip','bkip@uni.ac.ke',NULL,NULL),
(3,'Chen Amani','camani@uni.ac.ke',NULL,NULL),
(4,'Diana Muto','dmuto@uni.ac.ke',NULL,NULL),
(5,'Edwin Njagi','enjagi@uni.ac.ke',NULL,NULL);

INSERT INTO Student VALUES
(1,'Computer Science',2),
(2,'Mathematics',1),
(3,'Physics',3),
(4,'Cybersecurity',4),
(5,'Data Science',2);

/* -- Academic Staff -------------------------------------- */
INSERT INTO Person VALUES
(10,'Dr. Lemu Ouma','lemu@uni.ac.ke','0712-000000','2015-09-01'),
(11,'Prof. Nia Odhiambo','niao@uni.ac.ke','0712-000111','2010-02-15'),
(12,'Dr. Omar Kilonzo','okilo@uni.ac.ke','0712-000222','2018-01-20'),
(13,'Ms. Pendo Gachoka','pendo@uni.ac.ke','0712-000333','2019-07-07'),
(14,'Dr. Raj Singh','rsingh@uni.ac.ke','0712-000444','2013-04-12');

INSERT INTO AcademicStaff VALUES
(10,'PhD Cybersecurity','Senior Lecturer'),
(11,'PhD Mathematics','Professor'),
(12,'PhD Physics','Lecturer'),
(13,'MSc Computer Science','Assistant Lecturer'),
(14,'PhD Data Science','Senior Lecturer');

/* -- General Staff --------------------------------------- */
INSERT INTO Person VALUES
(20,'Grace Otieno','grace@uni.ac.ke','0713-000000','2018-03-15'),
(21,'Hassan Kariuki','hkariuki@uni.ac.ke','0713-000111','2016-06-22'),
(22,'Ivy Wanja','ivanja@uni.ac.ke','0713-000222','2019-11-04'),
(23,'Jacob Kiptoo','jkiptoo@uni.ac.ke','0713-000333','2020-05-19'),
(24,'Kara Mwangi','kmwangi@uni.ac.ke','0713-000444','2017-09-10');

INSERT INTO GeneralStaff VALUES
(20,'Finance'),
(21,'Library'),
(22,'IT Support'),
(23,'Registry'),
(24,'Accommodation');

/* -- Courses --------------------------------------------- */
INSERT INTO Course VALUES
(100,'CS101','Intro to Programming',3),
(101,'CS201','Data Structures',3),
(102,'MATH210','Linear Algebra',3),
(103,'PHY150','Classical Mechanics',4),
(104,'CYB310','Network Security',3);

/* -- Textbooks (6) -------------------------------------- */
INSERT INTO Textbook VALUES
('978-0131103627','The C Programming Language','Kernighan & Ritchie'),
('978-0262033848','Introduction to Algorithms','Cormen et al.'),
('978-0321573513','Linear Algebra and Its Applications','Lay'),
('978-0134093413','Computer Networking: A Top-Down Approach','Kurose & Ross'),
('978-0321193610','Physics for Scientists and Engineers','Serway & Jewett'),
('978-1492056812','Serious Python','K. B.');

/* -- Course <-> Textbook --------------------------------- */
INSERT INTO CourseTextbook VALUES
(100,'978-0131103627'),
(100,'978-1492056812'),
(101,'978-0131103627'),
(101,'978-0262033848'),
(102,'978-0321573513'),
(103,'978-0321193610'),
(104,'978-0134093413'),
(104,'978-0131103627');

/* -- Teaching (staff -> course) -------------------------- */
INSERT INTO Teaching VALUES
(10,100),(10,104),
(11,101),(11,102),
(12,103),
(13,100),
(14,101),(14,104);

/* -- Enrollments (students -> course) -------------------- */
INSERT INTO Enrollment VALUES
(1,100),(1,101),
(2,100),(2,102),
(3,103),
(4,104),
(5,100),(5,102);

/* =========================================================
   DEMO QUERIES
   ========================================================= */

/* a) List all students taking CS101 */
SELECT s.person_id,
       p.full_name
FROM Course       c
JOIN Enrollment   e ON c.course_id = e.course_id
JOIN Student      s ON e.person_id = s.person_id
JOIN Person       p ON s.person_id = p.person_id
WHERE c.code = 'CS101';

/* b) Academic staff teaching more than one course */
SELECT p.full_name,
       a.qualification,
       COUNT(t.course_id) AS course_count
FROM AcademicStaff a
JOIN Person        p ON a.person_id = p.person_id
JOIN Teaching      t ON a.person_id = t.person_id
GROUP BY a.person_id
HAVING COUNT(t.course_id) > 1;

/* c) Textbooks used in more than one course */
SELECT tb.isbn,
       tb.title,
       COUNT(ct.course_id) AS course_count
FROM Textbook tb
JOIN CourseTextbook ct ON tb.isbn = ct.isbn
GROUP BY tb.isbn
HAVING COUNT(ct.course_id) > 1;

-- Create the database
CREATE DATABASE AcademicManagementSystem;

-- Use the database
USE AcademicManagementSystem;

-- Create StudentInfo table
CREATE TABLE StudentInfo (
    STU_ID VARCHAR(10) PRIMARY KEY,
    STU_NAME VARCHAR(50) NOT NULL,
    DOB DATE,
    PHONE_NO VARCHAR(10),
    EMAIL_ID VARCHAR(50),
    ADDRESS TEXT
);

-- Create CoursesInfo table
CREATE TABLE CoursesInfo (
    COURSE_ID VARCHAR(10) PRIMARY KEY,
    COURSE_NAME VARCHAR(50) NOT NULL,
    COURSE_INSTRUCTOR_NAME VARCHAR(50)
);

-- Create EnrollmentInfo table with foreign key constraints
CREATE TABLE EnrollmentInfo (
    ENROLLMENT_ID VARCHAR(10) PRIMARY KEY,
    STU_ID VARCHAR(10),
    COURSE_ID VARCHAR(10),
    ENROLL_STATUS VARCHAR(20) CHECK (ENROLL_STATUS IN ('Enrolled', 'Not Enrolled')),
    FOREIGN KEY (STU_ID) REFERENCES StudentInfo(STU_ID),
    FOREIGN KEY (COURSE_ID) REFERENCES CoursesInfo(COURSE_ID)
);




-- Insert sample data into StudentInfo table
INSERT INTO StudentInfo (STU_ID, STU_NAME, DOB, PHONE_NO, EMAIL_ID, ADDRESS) VALUES
('S001', 'John Smith', '2000-05-15', 9878675432, 'john.smith@email.com', '123 Main St, City'),
('S002', 'Emma Wilson', '2001-03-22', 9878675412, 'emma.w@email.com', '456 Oak Ave, Town'),
('S003', 'Michael Brown', '2000-11-30', 9878675430, 'michael.b@email.com', '789 Pine Rd, Village'),
('S004', 'Sarah Davis', '2001-07-18', 9878675422, 'sarah.d@email.com', '321 Elm St, City'),
('S005', 'James Johnson', '2000-09-25', 9878675932, 'james.j@email.com', '654 Maple Dr, Town');

-- Insert sample data into CoursesInfo table
INSERT INTO CoursesInfo (COURSE_ID, COURSE_NAME, COURSE_INSTRUCTOR_NAME) VALUES
('C101', 'Introduction to Computer Science', 'Dr. Robert Anderson'),
('C102', 'Database Management Systems', 'Prof. Lisa Chen'),
('C103', 'Web Development', 'Mr. David Wilson'),
('C104', 'Data Structures', 'Dr. Emily Brown'),
('C105', 'Artificial Intelligence', 'Prof. Mark Thompson');

-- Insert sample data into EnrollmentInfo table
INSERT INTO EnrollmentInfo (ENROLLMENT_ID, STU_ID, COURSE_ID, ENROLL_STATUS) VALUES
('E0001', 'S001', 'C101', 'Enrolled'),
('E0002', 'S001', 'C102', 'Enrolled'),
('E0003', 'S002', 'C101', 'Enrolled'),
('E0004', 'S003', 'C103', 'Enrolled'),
('E0005', 'S004', 'C102', 'Not Enrolled'),
('E0006', 'S002', 'C104', 'Enrolled'),
('E0008', 'S003', 'C105', 'Not Enrolled'),
('E0009', 'S004', 'C101', 'Enrolled'),
('E0010', 'S005', 'C103', 'Enrolled');

-- Retrieve the Student Information 

SELECT * From  StudentInfo;
SELECT * FROM CoursesInfo;
SELECT * FROM EnrollmentInfo;

-- a) Write a query to retrieve student details, such as student name, contact informations, and Enrollment status 
SELECT 
    s.STU_ID,
    s.STU_NAME,
    s.PHONE_NO,
    s.EMAIL_ID,
    s.ADDRESS,
    e.ENROLL_STATUS,
    c.COURSE_NAME
FROM StudentInfo s
LEFT JOIN EnrollmentInfo e ON s.STU_ID = e.STU_ID
LEFT JOIN CoursesInfo c ON e.COURSE_ID = c.COURSE_ID;


-- b) Write a query to retrieve a list of courses in which a specific student is enrolled

SELECT 
    s.STU_NAME,
    c.COURSE_NAME,
    c.COURSE_INSTRUCTOR_NAME,
    e.ENROLL_STATUS
FROM StudentInfo s
JOIN EnrollmentInfo e ON s.STU_ID = e.STU_ID
JOIN CoursesInfo c ON e.COURSE_ID = c.COURSE_ID
WHERE s.STU_ID = 'S003';


-- c) Write a query to retrieve course information, including course name, instructor information.

SELECT 
    COURSE_ID,
    COURSE_NAME,
    COURSE_INSTRUCTOR_NAME,
    (SELECT COUNT(*) 
     FROM EnrollmentInfo e 
     WHERE e.COURSE_ID = c.COURSE_ID AND e.ENROLL_STATUS = 'Enrolled') as ENROLLED_STUDENTS
FROM CoursesInfo c;

-- d) Write a query to retrieve course information for a specific course .

SELECT 
    c.COURSE_ID,
    c.COURSE_NAME,
    c.COURSE_INSTRUCTOR_NAME,
    COUNT(e.STU_ID) as TOTAL_ENROLLMENTS,
    GROUP_CONCAT(s.STU_NAME) as ENROLLED_STUDENTS
FROM CoursesInfo c
LEFT JOIN EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
LEFT JOIN StudentInfo s ON e.STU_ID = s.STU_ID
WHERE c.COURSE_ID = 'C103'
GROUP BY c.COURSE_ID, c.COURSE_NAME, c.COURSE_INSTRUCTOR_NAME;


-- e) Write a query to retrieve course information for multiple courses.

SELECT 
    c.COURSE_ID,
    c.COURSE_NAME,
    c.COURSE_INSTRUCTOR_NAME,
    COUNT(e.STU_ID) as TOTAL_ENROLLMENTS
FROM CoursesInfo c
LEFT JOIN EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
WHERE c.COURSE_ID IN ('C104', 'C105')
GROUP BY c.COURSE_ID, c.COURSE_NAME, c.COURSE_INSTRUCTOR_NAME;

-- f) Test the queries to ensure accurate retrieval of student information.( execute the queries and verify the results against the expected output.)

-- Test 1: Count of students per course
SELECT 
    c.COURSE_NAME,
    COUNT(e.STU_ID) as STUDENT_COUNT,
    COUNT(CASE WHEN e.ENROLL_STATUS = 'Enrolled' THEN 1 END) as ENROLLED_COUNT
FROM CoursesInfo c
LEFT JOIN EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
GROUP BY c.COURSE_NAME;

-- Test 2: Verify enrollment status distribution
SELECT 
    ENROLL_STATUS,
    COUNT(*) as COUNT
FROM EnrollmentInfo
GROUP BY ENROLL_STATUS;

-- Test 3: Check for any students without enrollments
SELECT 
    s.STU_ID,
    s.STU_NAME,
    COUNT(e.ENROLLMENT_ID) as ENROLLMENT_COUNT
FROM StudentInfo s
LEFT JOIN EnrollmentInfo e ON s.STU_ID = e.STU_ID
GROUP BY s.STU_ID, s.STU_NAME
HAVING ENROLLMENT_COUNT = 1;

-- Test 4: Verify course enrollment details
SELECT 
    s.STU_NAME,
    COUNT(e.ENROLLMENT_ID) as TOTAL_ENROLLMENTS,
    SUM(CASE WHEN e.ENROLL_STATUS = 'Enrolled' THEN 1 ELSE 0 END) as ACTIVE_ENROLLMENTS
FROM StudentInfo s
LEFT JOIN EnrollmentInfo e ON s.STU_ID = e.STU_ID
GROUP BY s.STU_NAME;

-- Test 5: Complete enrollment report
SELECT 
    s.STU_NAME,
    c.COURSE_NAME,
    c.COURSE_INSTRUCTOR_NAME,
    e.ENROLL_STATUS,
    e.ENROLLMENT_ID
FROM StudentInfo s
JOIN EnrollmentInfo e ON s.STU_ID = e.STU_ID
JOIN CoursesInfo c ON e.COURSE_ID = c.COURSE_ID
ORDER BY s.STU_NAME, c.COURSE_NAME;


-- Reporting and Analytics 

-- a)  Write a query to retrieve the number of students enrolled in each course
SELECT 
    c.COURSE_ID,
    c.COURSE_NAME,
    COUNT(CASE WHEN e.ENROLL_STATUS = 'Enrolled' THEN 1 END) as ENROLLED_STUDENTS
FROM CoursesInfo c
LEFT JOIN EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
GROUP BY c.COURSE_ID, c.COURSE_NAME
ORDER BY ENROLLED_STUDENTS DESC;


-- b) Write a query to retrieve the list of students enrolled in a specific course

SELECT 
	c.COURSE_NAME, 
    s.STU_ID, 
    s.STU_NAME, 
    s.EMAIL_ID, 
    e.ENROLL_STATUS
FROM CoursesInfo c 
JOIN EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
JOIN StudentInfo s ON e.STU_ID = s.STU_ID
WHERE c.COURSE_ID = 'C101' AND e.ENROLL_STATUS = 'Enrolled'
ORDER BY s.STU_NAME;

-- c) Query to retrieve the count of enrolled students for each instructor
SELECT 
    c.COURSE_INSTRUCTOR_NAME,
    COUNT(DISTINCT CASE WHEN e.ENROLL_STATUS = 'Enrolled' THEN s.STU_ID END) as TOTAL_STUDENTS,
    GROUP_CONCAT(DISTINCT c.COURSE_NAME) as COURSES_TAUGHT
FROM CoursesInfo c
LEFT JOIN EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
LEFT JOIN StudentInfo s ON e.STU_ID = s.STU_ID
GROUP BY c.COURSE_INSTRUCTOR_NAME
ORDER BY TOTAL_STUDENTS DESC;

-- d) Query to retrieve students enrolled in multiple courses

SELECT 
    s.STU_ID,
    s.STU_NAME,
    COUNT(CASE WHEN e.ENROLL_STATUS = 'Enrolled' THEN 1 END) as ENROLLED_COURSES,
    GROUP_CONCAT(DISTINCT c.COURSE_NAME) as COURSE_LIST
FROM StudentInfo s
JOIN EnrollmentInfo e ON s.STU_ID = e.STU_ID
JOIN CoursesInfo c ON e.COURSE_ID = c.COURSE_ID
WHERE e.ENROLL_STATUS = 'Enrolled'
GROUP BY s.STU_ID, s.STU_NAME
HAVING ENROLLED_COURSES > 1
ORDER BY ENROLLED_COURSES DESC;


-- e) Query to retrieve courses with the highest number of enrolled students
SELECT 
    c.COURSE_ID,
    c.COURSE_NAME,
    c.COURSE_INSTRUCTOR_NAME,
    COUNT(CASE WHEN e.ENROLL_STATUS = 'Enrolled' THEN 1 END) as ENROLLED_STUDENTS,
    GROUP_CONCAT(DISTINCT s.STU_NAME) as STUDENT_LIST
FROM CoursesInfo c
LEFT JOIN EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
LEFT JOIN StudentInfo s ON e.STU_ID = s.STU_ID AND e.ENROLL_STATUS = 'Enrolled'
GROUP BY c.COURSE_ID, c.COURSE_NAME, c.COURSE_INSTRUCTOR_NAME
ORDER BY ENROLLED_STUDENTS DESC;

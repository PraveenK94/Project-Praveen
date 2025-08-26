-- Create database
CREATE DATABASE student_database;

-- Connect to the database
\c student_database

-- Create table
CREATE TABLE student_table (
    Student_id INTEGER PRIMARY KEY,
    Stu_name TEXT NOT NULL,
    Department TEXT NOT NULL,
    email_id TEXT UNIQUE,
    Phone_no NUMERIC,
    Address TEXT,
    Date_of_birth DATE,
    Gender TEXT CHECK (Gender IN ('Male', 'Female', 'Other')),
    Major TEXT,
    GPA NUMERIC CHECK (GPA >= 0 AND GPA <= 10),
    Grade TEXT CHECK (Grade IN ('A', 'B', 'C', 'D', 'F'))
);

-- Data Entry 
INSERT INTO student_table VALUES
(1, 'John Doe', 'Computer Science', 'john@email.com', 1234567890, '123 Main St', '2000-01-15', 'Male', 'Software Engineering', 8.5, 'A'),
(2, 'Jane Smith', 'Electronics', 'jane@email.com', 2345678901, '456 Oak Ave', '2001-03-20', 'Female', 'Electronics', 7.8, 'B'),
(3, 'Mike Johnson', 'Mechanical', 'mike@email.com', 3456789012, '789 Pine Rd', '2000-07-10', 'Male', 'Robotics', 4.5, 'C'),
(4, 'Sarah Williams', 'Computer Science', 'sarah@email.com', 4567890123, '321 Elm St', '2001-11-05', 'Female', 'AI', 9.0, 'A'),
(5, 'Tom Brown', 'Electronics', 'tom@email.com', 5678901234, '654 Maple Dr', '2000-09-25', 'Male', 'Communications', 4.8, 'C'),
(6, 'Emily Davis', 'Mechanical', 'emily@email.com', 6789012345, '987 Cedar Ln', '2001-05-30', 'Female', 'Manufacturing', 8.2, 'B'),
(7, 'David Wilson', 'Computer Science', 'david@email.com', 7890123456, '147 Birch Rd', '2000-12-12', 'Male', 'Cybersecurity', 7.5, 'B'),
(8, 'Lisa Anderson', 'Electronics', 'lisa@email.com', 8901234567, '258 Pine St', '2001-08-18', 'Female', 'VLSI', 6.9, 'B'),
(9, 'James Taylor', 'Mechanical', 'james@email.com', 9012345678, '369 Oak Rd', '2000-04-22', 'Male', 'Automotive', 3.8, 'D'),
(10, 'Amy Martin', 'Computer Science', 'amy@email.com', 0123456789, '741 Maple Ave', '2001-02-28', 'Female', 'Data Science', 9.5, 'A');


-- Student Information Retrieval

-- Retrieve and Sort by Grade:

SELECT * FROM student_table ORDER BY Grade ASC;

-- Query for Male Students:

SELECT * FROM student_table WHERE Gender = 'Male';

-- Query for GPA less than 5.0:

SELECT * FROM student_table WHERE GPA < 5.0;

-- Update Student Email and Grade:

UPDATE student_table 
SET email_id = 'newemail@email.com', Grade = 'B'
WHERE Student_id = 1;

-- Query for Grade 'B' Students:

SELECT Stu_name, 
       DATE_PART('year', AGE(CURRENT_DATE, Date_of_birth)) as age
FROM student_table 
WHERE Grade = 'B';

-- Rename Table: 

ALTER TABLE student_table RENAME TO student_info;

-- Highest GPA Student:

SELECT Stu_name, GPA
FROM student_info
WHERE GPA = (SELECT MAX(GPA) FROM student_info);

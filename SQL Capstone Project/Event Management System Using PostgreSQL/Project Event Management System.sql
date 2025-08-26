
-- Create database

CREATE DATABASE EventsManagement;


-- Connect to the database

\c EventsManagement


-- Create table

CREATE TABLE Events (
    Event_Id SERIAL PRIMARY KEY,
    Event_Name VARCHAR(100) NOT NULL,
    Event_Date DATE NOT NULL,
    Event_Location VARCHAR(200) NOT NULL,
    Event_Description TEXT
);
-- Create table
CREATE TABLE Attendees (
    Attendee_Id SERIAL PRIMARY KEY,
    Attendee_Name VARCHAR(100) NOT NULL,
    Attendee_Phone VARCHAR(15),
    Attendee_Email VARCHAR(100) UNIQUE NOT NULL,
    Attendee_City VARCHAR(50)
);
-- Create table
CREATE TABLE Registrations (
    Registration_id SERIAL PRIMARY KEY,
    Event_Id INTEGER REFERENCES Events(Event_Id),
    Attendee_Id INTEGER REFERENCES Attendees(Attendee_Id),
    Registration_Date DATE DEFAULT CURRENT_DATE,
    Registration_Amount DECIMAL(10,2),
    UNIQUE(Event_Id, Attendee_Id)
);

-- Insert Events
INSERT INTO Events (Event_Name, Event_Date, Event_Location, Event_Description) VALUES
('Tech Conference 2024', '2024-03-15', 'Convention Center', 'Annual technology conference'),
('Music Festival', '2024-04-20', 'City Park', 'Summer music festival'),
('Business Summit', '2024-05-10', 'Grand Hotel', 'Leadership and innovation summit'),
('Art Exhibition', '2024-06-01', 'Art Gallery', 'Modern art showcase'),
('Food Festival', '2024-07-15', 'Downtown Square', 'International cuisine festival');

-- Insert Attendees
INSERT INTO Attendees (Attendee_Name, Attendee_Phone, Attendee_Email, Attendee_City) VALUES
('John Smith', '1234567890', 'john@email.com', 'New York'),
('Sarah Johnson', '2345678901', 'sarah@email.com', 'Los Angeles'),
('Michael Brown', [REDACTED:BANK_ACCOUNT_NUMBER], 'michael@email.com', 'Chicago'),
('Emily Davis', [REDACTED:BANK_ACCOUNT_NUMBER], 'emily@email.com', 'Houston'),
('David Wilson', [REDACTED:BANK_ACCOUNT_NUMBER], 'david@email.com', 'Phoenix');

-- Insert Registrations
INSERT INTO Registrations (Event_Id, Attendee_Id, Registration_Amount) VALUES
(1, 1, 100.00),
(1, 2, 100.00),
(2, 3, 75.50),
(3, 4, 150.00),
(4, 5, 50.00);


-- a) Insert new event
INSERT INTO Events (Event_Name, Event_Date, Event_Location, Event_Description)
VALUES ('Workshop 2024', '2024-08-20', 'Training Center', 'Technical workshop');

-- b) Update event information
UPDATE Events 
SET Event_Location = 'New Convention Center', 
    Event_Description = 'Updated technology conference'
WHERE Event_Id = 1;

-- c) Delete event
DELETE FROM Events WHERE Event_Id = 5;


-- a) Insert new attendee
INSERT INTO Attendees (Attendee_Name, Attendee_Phone, Attendee_Email, Attendee_City)
VALUES ('Lisa Anderson', '6789012345', 'lisa@email.com', 'Miami');

-- b) Register attendee for event
INSERT INTO Registrations (Event_Id, Attendee_Id, Registration_Amount)
VALUES (1, 6, 100.00);

-- List all events with their attendee count
SELECT 
    e.Event_Id,
    e.Event_Name,
    e.Event_Date,
    COUNT(r.Attendee_Id) as Attendee_Count
FROM Events e
LEFT JOIN Registrations r ON e.Event_Id = r.Event_Id
GROUP BY e.Event_Id, e.Event_Name, e.Event_Date
ORDER BY e.Event_Date;

-- List attendees for a specific event
SELECT 
    a.Attendee_Name,
    a.Attendee_Email,
    a.Attendee_City,
    r.Registration_Date
FROM Attendees a
JOIN Registrations r ON a.Attendee_Id = r.Attendee_Id
WHERE r.Event_Id = 1;

-- Calculate total registration amount by event
SELECT 
    e.Event_Name,
    SUM(r.Registration_Amount) as Total_Amount,
    COUNT(r.Attendee_Id) as Attendee_Count
FROM Events e
LEFT JOIN Registrations r ON e.Event_Id = r.Event_Id
GROUP BY e.Event_Name;

-- Find events with no registrations
SELECT Event_Name, Event_Date
FROM Events e
LEFT JOIN Registrations r ON e.Event_Id = r.Event_Id
WHERE r.Registration_id IS NULL;

-- List attendees who registered for multiple events
SELECT 
    a.Attendee_Name,
    COUNT(r.Event_Id) as Event_Count
FROM Attendees a
JOIN Registrations r ON a.Attendee_Id = r.Attendee_Id
GROUP BY a.Attendee_Name
HAVING COUNT(r.Event_Id) > 1;

-- Get upcoming events
SELECT Event_Name, Event_Date, Event_Location
FROM Events
WHERE Event_Date > CURRENT_DATE
ORDER BY Event_Date;


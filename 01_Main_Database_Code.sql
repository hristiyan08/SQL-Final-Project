-- Creating the database
CREATE DATABASE HealthyDesk;

-- Creating security key and certificate for encrypting the personal information
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'HealtyDESKAdmin12452W3245243435!';

CREATE CERTIFICATE PatientCert WITH SUBJECT = 'Patient EGN Protection';

CREATE SYMMETRIC KEY PatientEgnKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE PatientCert;

-- Creating the tables

CREATE TABLE Patients(
PatientID INT IDENTITY(1,1) PRIMARY KEY,
PatientName NVARCHAR(100),
PatientEGN VARBINARY(max),
Diagnosis NVARCHAR(120)
);

CREATE TABLE Doctors(
DoctorID INT IDENTITY(1,1) PRIMARY KEY,
DoctorName NVARCHAR(100),
DoctorSpeciality NVARCHAR(100)
);

CREATE TABLE RoomTypes (
RoomTypeID INT IDENTITY(1,1) PRIMARY KEY,
RoomType NVARCHAR(100)
);

CREATE TABLE Rooms(
RoomID INT IDENTITY(1,1) PRIMARY KEY,
RoomFloor INT,
RoomDepartment NVARCHAR(100),
RoomTypeID INT,

FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID)
);

CREATE TABLE Appointments (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY, 
    PatientID INT, 
    DoctorID INT,
    AppointmentDate DATE,
    AppointmentStatus NVARCHAR(100),

    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Inserting the patients
INSERT INTO Patients (PatientName, PatientEGN, Diagnosis)
VALUES 
('Иван Иванов', CAST('8501011234' AS VARBINARY(MAX)), 'Грип'),
('Мария Петрова', CAST('9005124321' AS VARBINARY(MAX)), NULL),
('Георги Димитров', CAST('7811225566' AS VARBINARY(MAX)), 'Хипертония'),
('Елена Николова', CAST('9503147788' AS VARBINARY(MAX)), 'Мигрена'),
('Иванка Стоянова', CAST('6507089900' AS VARBINARY(MAX)), 'Астма');

-- Inserting the doctors
INSERT INTO Doctors (DoctorName, DoctorSpeciality)
VALUES 
('Д-р Петров', 'Кардиология'),
('Д-р Георгиева', 'Неврология'),
('Д-р Симеонов', 'Обща медицина');

-- Inserting the room types (1:N for Rooms)
INSERT INTO RoomTypes (RoomType)
VALUES 
('Стандартна двойна'),
('Единична ВИП'),
('Интензивно отделение');

-- Inserting the rooms
INSERT INTO Rooms (RoomFloor, RoomDepartment, RoomTypeID)
VALUES 
(1, 'Спешно отделение', 3),
(2, 'Кардиология', 1),
(2, 'Кардиология', 2),
(3, 'Неврология', 1);

-- Inserting the appointments (N:M relation between Patients и Doctors)
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentStatus)
VALUES 
(1, 3, '2023-10-01', 'Приключен'),
(2, 2, '2023-10-05', 'Отменен'),
(3, 1, '2023-11-15', 'Приключен'),
(4, 2, '2024-01-20', 'Планиран'),
(1, 1, '2024-02-10', 'Планиран'), 
(5, 3, GETDATE(), 'Текущ');

-- Where clause
SELECT *
FROM Patients
WHERE Diagnosis = 'Грип';

-- AND/OR Clause
SELECT * 
FROM Doctors
WHERE DoctorSpeciality = 'Кардиология' OR  DoctorSpeciality = 'Обща медицина';

-- DISCTINCT, ORDER BY AND JOINS Clause
SELECT *
FROM dbo.vw_AppointmentDetails
ORDER BY AppointmentDate DESC;

-- Like clause
SELECT rt.RoomType, r.RoomFloor, r.RoomDepartment
FROM Rooms AS r
JOIN RoomTypes AS rt ON r.RoomTypeID = rt.RoomTypeID
WHERE rt.RoomType LIKE 'Единична%';

-- COUNT() + GROUP BY + Having
SELECT a.AppointmentStatus, COUNT(a.AppointmentID) AS CompletedAppointments
FROM Appointments AS a
GROUP BY a.AppointmentStatus
HAVING a.AppointmentStatus = 'Приключен';

-- UPDATE operation
UPDATE Rooms
SET RoomFloor = 3
WHERE RoomDepartment = 'Кардиология';

-- DELETE operation
DELETE FROM Appointments
WHERE AppointmentStatus = 'Отменен';

-- Select the history of pacient (IDEA)
SELECT *
FROM dbo.vw_AppointmentDetails
WHERE PatientName = 'Иван Иванов';

-- Select the doctor's schedule from stored procedure and view (MY OWN IDEA)
EXEC sp_GetDoctorSchedule @DoctorName = 'Д-р Петров', @Status = 'Планиран';

-- Select the active patients (IDEA)
SELECT *
FROM dbo.vw_AppointmentDetails
WHERE AppointmentStatus != 'Приключен';

-- Select PatientInformation and how many days are left from appointment
SELECT 
    PatientName, 
    DoctorName, 
    AppointmentDate,
    dbo.fn_DaysUntilAppointment(AppointmentDate) AS [Дни до прегледа]
FROM vw_AppointmentDetails
WHERE AppointmentStatus = 'Планиран';

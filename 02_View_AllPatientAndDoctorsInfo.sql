-- Creating view for getting fully information about the doctors and patients

CREATE VIEW vw_AppointmentDetails AS
SELECT 
    d.DoctorName, 
    d.DoctorSpeciality, 
    p.PatientName, 
    p.PatientEGN, 
    a.AppointmentDate, 
    a.AppointmentStatus
FROM Appointments AS a
INNER JOIN Patients AS p ON a.PatientID = p.PatientID
INNER JOIN Doctors AS d ON a.DoctorID = d.DoctorID;
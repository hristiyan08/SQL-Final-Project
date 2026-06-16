-- Creating Stored Procedure for getting the schedule of doctor

CREATE PROCEDURE sp_GetDoctorSchedule
    @DoctorName NVARCHAR(100),
    @Status NVARCHAR(100)
AS
BEGIN
    SELECT * FROM vw_AppointmentDetails
    WHERE DoctorName = @DoctorName AND AppointmentStatus = @Status
    ORDER BY AppointmentDate ASC;
END;
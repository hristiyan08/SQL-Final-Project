-- Creating a scalar function that calculate how many days are left until appointment

CREATE FUNCTION fn_DaysUntilAppointment (
@AppDate DATE
)
RETURNS INT AS
BEGIN
RETURN DATEDIFF(DAY, GETDATE(), @AppDate);
END;
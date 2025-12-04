
CREATE FUNCTION dbo.fn_GetAverageRating(@BookId INT)
RETURNS DECIMAL(3,2)
AS
BEGIN
    DECLARE @avg DECIMAL(18,4);
    SELECT @avg = AVG(CAST(Rating AS DECIMAL(3,2))) FROM Reviews WHERE BookId = @BookId;
    IF @avg IS NULL SET @avg = 0;
    RETURN ROUND(@avg,2);
END;
GO


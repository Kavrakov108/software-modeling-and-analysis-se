-- Тригер: при промяна в Reviews -> ъпдейта AverageRating и ReviewCount в Books
-- (работи за INSERT, UPDATE, DELETE)
-- ---------------------------------------------------------
CREATE TRIGGER trg_Reviews_UpdateBookRating
ON Reviews
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- съберем всички засегнати BookId от INSERTED и DELETED
    DECLARE @tmp TABLE (BookId INT PRIMARY KEY);
    INSERT INTO @tmp (BookId)
    SELECT DISTINCT BookId FROM (
        SELECT BookId FROM inserted
        UNION
        SELECT BookId FROM deleted
    ) AS t WHERE BookId IS NOT NULL;

    DECLARE @b INT;
    DECLARE cur CURSOR FOR SELECT BookId FROM @tmp;
    OPEN cur;
    FETCH NEXT FROM cur INTO @b;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @avg DECIMAL(3,2);
        DECLARE @cnt INT;
        SELECT @avg = dbo.fn_GetAverageRating(@b);
        SELECT @cnt = COUNT(*) FROM Reviews WHERE BookId = @b;

        UPDATE Books
        SET AverageRating = @avg, ReviewCount = ISNULL(@cnt,0)
        WHERE BookId = @b;

        FETCH NEXT FROM cur INTO @b;
    END
    CLOSE cur;
    DEALLOCATE cur;
END;
GO
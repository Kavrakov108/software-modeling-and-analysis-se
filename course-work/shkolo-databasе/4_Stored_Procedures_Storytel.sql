-- Съхранена процедура: Добавя ревю (може да се използва от приложението)
-- Тя прави INSERT в Reviews; тригерът ще актуализира книгата
-- ---------------------------------------------------------
CREATE PROCEDURE dbo.sp_AddReview
    @UserId INT,
    @BookId INT,
    @Rating INT,
    @Title NVARCHAR(200) = NULL,
    @Comment NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Reviews(UserId, BookId, Rating, Title, Comment)
        VALUES(@UserId, @BookId, @Rating, @Title, @Comment);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('sp_AddReview failed: %s', 16, 1, @err);
    END CATCH
END;
GO
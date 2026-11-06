-- Example of using Transactions.
BEGIN TRY
    BEGIN TRAN

		-- Do stuff

    COMMIT TRAN
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
    DECLARE @ErrNum INT = ERROR_NUMBER();
    DECLARE @ErrLine INT = ERROR_LINE();
    RAISERROR('Upsert failed (%d) at line %d: %s', 16, 1, @ErrNum, @ErrLine, @ErrMsg);
END CATCH
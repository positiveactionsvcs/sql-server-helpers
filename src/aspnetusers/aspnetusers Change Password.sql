-- Change a password in the aspnet Users database.
DECLARE @UserName NVARCHAR(256);
DECLARE @Password NVARCHAR(128);
DECLARE @Application NVARCHAR(256);
DECLARE @PasswordSalt NVARCHAR(128);
DECLARE @CurrentTimeUtc DATETIME;

SET @UserName = N'admin1';
SET @Password = N'newpass123';
SET @Application = N'MyAppName';

SELECT
    @PasswordSalt = M.PasswordSalt
FROM
    dbo.aspnet_Membership AS M
    INNER JOIN
        dbo.aspnet_Users AS U ON M.UserID = U.UserID
    INNER JOIN dbo.aspnet_Applications AS A
        ON U.ApplicationId = A.ApplicationId
WHERE
    U.UserName = @UserName
    AND A.ApplicationName = @Application

SET @CurrentTimeUtc = GETUTCDATE()

EXEC dbo.aspnet_Membership_SetPassword
    @Application,
    @UserName,
    @Password,
    @PasswordSalt,
    @CurrentTimeUtc

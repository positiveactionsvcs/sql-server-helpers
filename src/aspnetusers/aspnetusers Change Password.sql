declare @UserName nvarchar(256)    
declare @Password nvarchar(128)    
declare @Application nvarchar(256)    
declare @PasswordSalt nvarchar(128)    
declare @CurrentTimeUtc datetime

set @UserName = 'X'    
set @Password = 'Y'    
set @Application = 'Z'    
set @PasswordSalt = (SELECT 1 PasswordSalt FROM aspnet_Membership WHERE UserID IN 
						(SELECT UserID FROM aspnet_Users u, aspnet_Applications a WHERE u.UserName = @UserName 
						AND a.ApplicationName = @Application AND u.ApplicationId = a.ApplicationId))    
set @CurrentTimeUtc = getutcdate()

exec dbo.aspnet_Membership_SetPassword @Application, @UserName, @Password, @PasswordSalt, @CurrentTimeUtc
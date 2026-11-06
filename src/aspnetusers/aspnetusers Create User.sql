-- Create a user in the aspnet Users database.
DECLARE @Now DATETIME
SET @Now = GETDATE()

-- NOTE: Creates a user with a Clear Text password.
EXEC aspnet_Membership_CreateUser
	@ApplicationName = 'MyAppName',
	@UserName = 'admin3',
	@Password = 'pass@word1', 
	@PasswordSalt = '',
	@Email = 'admin1@contoso.com',
	@PasswordQuestion = '',
	@PasswordAnswer = '',
	@IsApproved = 1,
	@CurrentTimeUtc = @Now,
	--@CreateDate = @Now,
	--@UniqueEmail = 0,
	@PasswordFormat = 0,
	@UserId = NULL

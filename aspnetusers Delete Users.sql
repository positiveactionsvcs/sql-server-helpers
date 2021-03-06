SELECT UserID, UserName
into #temp
FROM aspnet_Users
WHERE UserName in ('X','Y','Z')
 
-- Adjust the WHERE Clause to filter the users
-- for example WHERE UserName LIKE 'MEMBER%'
-- would delete all users whose username started with 'MEMBER'
 
DELETE FROM dbo.aspnet_Membership WHERE UserId IN (Select UserId from #temp) 
DELETE FROM dbo.aspnet_UsersInRoles WHERE UserId IN (Select UserId from #temp)
DELETE FROM dbo.aspnet_Profile WHERE UserId IN (Select UserId from #temp)
DELETE FROM dbo.aspnet_PersonalizationPerUser WHERE UserId IN (Select UserId from #temp)
DELETE FROM dbo.aspnet_Users WHERE UserId IN (Select UserId from #temp)

DROP TABLE #temp
SET IDENTITY_INSERT dbo.sysdiagrams ON
GO

INSERT INTO dbo.sysdiagrams 
	([name], [principal_id], [diagram_id], [version], [definition])
	SELECT [name], [principal_id], [diagram_id], [version], [definition] 
	FROM <DATABASENAME>.dbo.sysdiagrams
GO
	
SET IDENTITY_INSERT dbo.sysdiagrams OFF
GO

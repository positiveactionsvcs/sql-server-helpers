-- List (and change) database compatability version.
DECLARE @DatabaseName VARCHAR(100) = 'PMA2'

SELECT
	[name],
	[compatibility_level]
FROM
	sys.databases
WHERE
	[name] = @DatabaseName

-- Level | SQL Server Version 
------------------------------------
-- 80	 | SQL Server 2000
-- 90	 | SQL Server 2005
-- 100	 | SQL Server 2008 / 2008 R2
-- 110	 | SQL Server 2012
-- 120	 | SQL Server 2014
-- 130	 | SQL Server 2016
-- 140	 | SQL Server 2017
-- 150	 | SQL Server 2019
-- 160	 | SQL Server 2022
--ALTER DATABASE PMA2
--SET COMPATIBILITY_LEVEL = 140;

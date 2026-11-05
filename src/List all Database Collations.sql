-- List all database collations, e.g. SQL_Latin1_General_CP1_CI_AS
SELECT
	name,
	collation_name
FROM
	sys.databases

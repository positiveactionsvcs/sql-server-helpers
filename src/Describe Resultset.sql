-- Describe the metadata of the results that would be returned by the SELECT statement.
SELECT
	*
FROM
	sys.dm_exec_describe_first_result_set(
	-- Write your SELECT statement here.
	N'SELECT ...',
	NULL,
	0
);

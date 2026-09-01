SELECT *
FROM sys.dm_exec_describe_first_result_set(
N'SELECT ...',
NULL,
0
);
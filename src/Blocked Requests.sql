-- Show all currently executing requests that are being blocked by another session.
SELECT
    r.session_id,
    r.blocking_session_id,
    r.wait_type,
    r.wait_time,
    DB_NAME(r.database_id) AS [database_name],
    s.login_name,
    s.host_name,
    s.program_name,
    t.text
FROM
    sys.dm_exec_requests r
JOIN
    sys.dm_exec_sessions s
    ON r.session_id = s.session_id
CROSS APPLY
    sys.dm_exec_sql_text(r.sql_handle) t
WHERE
    r.blocking_session_id > 0

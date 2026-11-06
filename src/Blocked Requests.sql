-- Show all currently executing requests that are waiting on (blocked by) another session
SELECT
    r.[session_id],                             -- Session ID of the blocked request
    r.[blocking_session_id],                    -- Session ID that is causing the block
    r.[wait_type],                              -- Type of wait the blocked session is experiencing (e.g. LCK_M_X)
    r.[wait_resource],                          -- Specific resource being waited on
    r.[wait_time],                              -- Time spent waiting (in milliseconds)
    r.[command],                                -- Type of command being executed (SELECT, UPDATE etc.)
    t.[text],                                   -- SQL statement currently being executed
    DB_NAME(r.database_id) AS [database_name],  -- Database where the request is running
    s.[login_name],                             -- SQL Server login executing the request
    s.[host_name],                              -- Client machine name where the connection originated
    s.[program_name],                           -- Application name (e.g. SSMS, .NET application, Power BI)
    r.[status],                                 -- Running, suspended, runnable, etc.
    s.[last_request_start_time]                 -- When the request started
FROM
    sys.dm_exec_requests r                      -- Active requests currently executing
JOIN
    sys.dm_exec_sessions s                      -- Session-level information
    ON r.[session_id] = s.[session_id]
CROSS APPLY
    sys.dm_exec_sql_text(r.[sql_handle]) t      -- Retrieves the SQL text for the request
WHERE
    r.[blocking_session_id] > 0                 -- Only show sessions that are blocked
ORDER BY
    r.[wait_time] DESC                          -- Show longest waiting sessions first
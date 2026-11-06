-- View the current state, storage size and usage of the Query Store.
SELECT
    [actual_state_desc],
    [current_storage_size_mb],
    [max_storage_size_mb],
    CAST(
        [current_storage_size_mb] * 100.0
        / NULLIF([max_storage_size_mb], 0)
        AS DECIMAL(5,2)
    ) AS pct_used,
    [readonly_reason]
FROM
    sys.database_query_store_options

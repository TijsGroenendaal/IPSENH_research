EXPLAIN (ANALYSE ON, FORMAT JSON, BUFFERS ON)
SELECT
    COUNT(*),
    COUNT(*)::FLOAT / (
        SELECT COUNT(*)
        FROM timeseries AS internal
        WHERE
            internal.resource = 5001 AND
            internal.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'
    )::FLOAT * 100 AS percentage
FROM timeseries AS external
WHERE
    external.resource = 5001 AND
    external.status = true AND
    external.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'

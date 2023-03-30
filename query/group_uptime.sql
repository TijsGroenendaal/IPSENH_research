EXPLAIN (ANALYSE ON, FORMAT JSON, BUFFERS ON)
SELECT
    COUNT(*),
    COUNT(*)::FLOAT / (
        SELECT COUNT(*)
        FROM timeseries AS internal
        INNER JOIN resources r ON r.id = internal.resource
        WHERE
            r.r_group = 5 AND
            internal.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'
    )::FLOAT * 100 AS percentage
FROM timeseries AS external
INNER JOIN resources r ON r.id = external.resource
WHERE
    r.r_group = 5 AND
    external.status = true AND
    external.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'

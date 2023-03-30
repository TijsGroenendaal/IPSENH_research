EXPLAIN (ANALYSE ON, FORMAT JSON, BUFFERS ON)
SELECT
    external.resource,
    count(*)::FLOAT,
    (COUNT(*)::FLOAT / (
        SELECT COUNT(*)
        FROM timeseries AS internal
        WHERE
            internal.resource = external.resource AND
            internal.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'
        )::FLOAT) * 100 AS percentage
FROM
    timeseries AS external
WHERE
    status = TRUE AND
    external.resource = 5005 AND
    external.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'
GROUP BY external.resource

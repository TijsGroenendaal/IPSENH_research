EXPLAIN (FORMAT JSON)
SELECT
    COUNT(*)::FLOAT / (
        SELECT COUNT(*)
        FROM timeseries AS internal
        WHERE internal.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'
    )::FLOAT * 100 AS percentage
FROM timeseries AS external
WHERE
    external.status = true AND
    external.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'
EXPLAIN (ANALYSE ON, FORMAT JSON, BUFFERS ON)
SELECT
    resource,
    COUNT(*)
FROM timeseries
WHERE
    status = true AND
    datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59'
GROUP BY resource
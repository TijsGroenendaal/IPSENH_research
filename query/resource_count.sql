EXPLAIN (ANALYSE ON, FORMAT JSON, BUFFERS ON)
SELECT
    resource,
    COUNT(*)
FROM timeseries
WHERE
    status = true AND
    datetime BETWEEN '2020-02-01' AND '2020-02-13 23:59:59'
GROUP BY resource

EXPLAIN (ANALYZE ON, FORMAT JSON)
SELECT
    count(*)
FROM timeseries
GROUP BY resource

EXPLAIN (ANALYZE ON, FORMAT JSON)
SELECT
    count(*)
FROM timeseries
WHERE resource = 1

SELECT
    COUNT(*)
FROM timeseries
WHERE
    datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:59' AND
    status = true
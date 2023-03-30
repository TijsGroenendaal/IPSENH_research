EXPLAIN (ANALYSE ON, FORMAT JSON, BUFFERS ON)
SELECT
    external.resource,
    DATE_TRUNC('day', external.datetime) AS date,
    (COUNT(*)::FLOAT / internal.count) * 100 AS percentage
FROM timeseries AS external
INNER JOIN (
    SELECT
        COUNT(*),
        internal.resource,
        DATE_TRUNC('day', internal.datetime) AS date
    FROM timeseries AS internal
    INNER JOIN resources r on internal.resource = r.id
    WHERE r.r_group = 5
    GROUP BY
        internal.resource,
        DATE_TRUNC('day', internal.datetime)
    ) internal ON internal.resource = external.resource AND internal.date = DATE_TRUNC('day', external.datetime)
WHERE
    status = TRUE AND
    external.datetime BETWEEN '2020-01-01' AND '2020-01-31 23:59:49'
GROUP BY external.resource, DATE_TRUNC('day', external.datetime), internal.count

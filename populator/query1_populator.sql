DROP TABLE IF EXISTS timeseries;

CREATE TABLE timeseries (
    id uuid PRIMARY KEY,
    datetime timestamp,
    status boolean,
    resource int
);

do
$$
    declare
        i record;
    begin
        for i in 1..100 loop
            INSERT INTO timeseries
            SELECT
                gen_random_uuid() as id,
                -- Add 20 seconds to each serie
                ('2020-01-01 00:00:00.000'::timestamp) + ((serie * 30) * interval '1 minute') as datetime,
                random() * 100 > 10 as status,
                i
            FROM generate_series(1, 267840) as serie;
        end loop;
    end;
$$;

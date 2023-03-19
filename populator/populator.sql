DROP TABLE IF EXISTS timeseries;
DROP TABLE IF EXISTS resources;
DROP TABLE IF EXISTS resource_group;

CREATE table resource_group (
    id int PRIMARY KEY
);

CREATE TABLE resources (

    id int PRIMARY KEY,
    r_group int REFERENCES resource_group(id)
);

CREATE TABLE timeseries (
    id uuid PRIMARY KEY,
    datetime timestamp,
    status boolean,
    resource int REFERENCES resources(id)
);

do
$$
    declare
        r_group record;
        resource record;
	resource_id integer;
    begin
        for r_group in 1..10 loop
            INSERT INTO resource_group
            VALUES (r_group);
            for resource in 1..10 loop
		resource_id = (r_group * 1000) + resource;
                INSERT INTO resources
                VALUES (resource_id, r_group);

                    INSERT INTO timeseries
                    SELECT
                        gen_random_uuid() as id,
                        -- Add 10 seconds to each series
                        ('2020-01-01 00:00:00.000'::timestamp) + ((serie * 10) * interval '1 second') as datetime,
                        random() * 100 > 2 as status,
                        resource_id
                    FROM generate_series(1, 535680) as serie;
		    raise notice 'inserted resource %', resource_id;
                end loop;
            end loop;
    end;
$$;

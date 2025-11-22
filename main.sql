-- read the data and save as csv
copy (
    select * from read_json('./public/data/interim/*.json')
    ) to 'public/data/processed/refugi.csv' with csv header;

-- create a table with SQL
create table
    refugi as
select
    *
from
    read_json ('./data/interim/*.json');



-- map all huts on a map

\copy (SELECT * FROM my_table) TO '/path/to/file.csv' WITH CSV HEADER;

-- compare points to Alta Via 1 track

-- load the line from file into a temporary helper table called 'line_source'
WITH line_source AS (
    SELECT geom FROM ST_Read('./data/interim/av1/av1-track.geojson')
    )

-- compare your points to that line
SELECT 
    p.geo, 
    ST_Distance(
        ST_Point(p.geo.coordinates[1], p.geo.coordinates[2]), 
        l.geom
    ) as distance_degrees
FROM refugi p, line_source l
WHERE 
    ST_DWithin(
        ST_Point(p.geo.coordinates[1], p.geo.coordinates[2]), 
        l.geom, 
        0.001
    );
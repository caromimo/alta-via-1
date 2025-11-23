INSTALL spatial; 
LOAD spatial;

-- create table with all huts (CAI and others)
create table all_huts as select * from read_json('./public/data/interim/*.json', union_by_name=true);

-- compare points to Alta Via 1 track
-- load the line from file into a temporary helper table called 'line_source'
WITH line_source AS (
    SELECT geom FROM ST_Read('./public/data/processed/av1/av1-track.geojson')
    )
-- compare your points to that line
SELECT 
    r.title, r.geo, 
    ST_Distance(
        ST_Point(r.geo.coordinates[1], r.geo.coordinates[2]), 
        l.geom
    ) as distance_degrees
FROM refugi r, line_source l
WHERE 
    ST_DWithin(
        ST_Point(r.geo.coordinates[1], r.geo.coordinates[2]), 
        l.geom, 
        0.005
    );
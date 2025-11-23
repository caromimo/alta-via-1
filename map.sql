-- Map the huts with only SQL and geojson.io

INSTALL spatial; LOAD spatial;

COPY (
    SELECT 
        -- 1. GEOMETRY: Convert your struct to a Point
        -- coordinates[1] is Longitude, coordinates[2] is Latitude
        ST_Point(geo.coordinates[1], geo.coordinates[2]) as geom,
        
        -- 2. PROPERTIES: These will appear in the popup on the map
        title as name
        
    FROM refugi
    -- Optional: Filter out rows where geo is null
    WHERE geo IS NOT NULL
) 
TO 'italian-alpine-club-huts.geojson'
WITH (FORMAT GDAL, DRIVER 'GeoJSON');

-- then copy and paste the content of the geojson in geojson.io
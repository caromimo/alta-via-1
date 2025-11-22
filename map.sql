-- Map the huts with only SQL and  geojson.io

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




COPY (
    SELECT 
        -- 1. GEOMETRY: Convert your struct to a Point
        -- coordinates[1] is Longitude, coordinates[2] is Latitude
        ST_Point(geo.coordinates[1], geo.coordinates[2]) as geom,
        
        -- 2. PROPERTIES: These will appear in the popup on the map
        title as name,
        altitude_geo as elevation,
        created_at
        
    FROM my_places
    -- Optional: Filter out rows where geo is null
    WHERE geo IS NOT NULL
) 
TO 'my_points.geojson'
WITH (FORMAT GDAL, DRIVER 'GeoJSON');



-- Make sure spatial is loaded
INSTALL spatial; LOAD spatial;
COPY (
    -- Part A: The Points (from your table)
    SELECT 
        ST_Point(geo.coordinates[1], geo.coordinates[2]) as geom,
        title as name,
        'Point' as type, -- Label it as a point
        altitude_geo as extra_info
    FROM my_places
    WHERE geo IS NOT NULL

    UNION ALL

    -- Part B: The Line (from your file)
    SELECT 
        ST_Read('path/to/your/folder/line.geojson') as geom,
        'My Hiking Route' as name,
        'Route' as type,
        NULL as extra_info -- Must match column count of Part A
) 
TO 'complete_map.geojson'
WITH (FORMAT GDAL, DRIVER 'GeoJSON');
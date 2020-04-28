-- This script should return a query as a GeoJSON object. Properties are not
-- defined, but rather take the names of the alias as prefix, and a number as
-- suffix (f = f1, f1, f3)

-- Returns rows as JSON
SELECT row_to_json(fc) FROM (
  -- Creates "TYPE" level
	SELECT 'FeatureCollection' As type, 
    -- Returns arrays as JSON, creates "features" level
    array_to_json(array_agg(f)) As features 
      FROM (
            -- Creates "Feature" level
		        SELECT 'Feature' As type,
              -- Returns geometry as GEOJSON "geometry" object or row as
              -- geoJSON "feature" object 
              ST_AsGeoJSON(ST_AsText(
                  --Gets current geom, transforms into WGS84(4326), casts type
                  --as geometry type
                  ST_Transform(lg.geom, 4326)))::json As geometry,
                    -- Features to be included in the properties level of
                    -- geoJSON object
		                row_to_json((id, name )) As properties 
                      -- Target database for query
                      FROM public.nyc_subway_stations As lg
	     ) As f
) As fc

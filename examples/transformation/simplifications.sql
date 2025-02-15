-- Licensed under the Apache License, Version 2.0 (the License); you may not use this file except
-- in compliance with the License. You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software distributed under the License
-- is distributed on an AS IS BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
-- or implied. See the License for the specific language governing permissions and limitations under
-- the License.
CREATE MATERIALIZED VIEW osm_highway_z10 AS
SELECT id, tags, geom
FROM (SELECT id, tags, st_simplifypreservetopology(geom, 78270 / power(2, 10)) AS geom FROM osm_highway) AS osm_highway
WHERE geom IS NOT NULL AND (st_area(st_envelope(geom)) > power((78270 / power(2, 10)), 2));

CREATE MATERIALIZED VIEW landuse_z10 AS
    WITH
    -- Set the size of 1 pixel at z10
    pixel_size AS (
        SELECT 78270 / power(2, 10) AS pixel_size
    ),
    -- Set the minimum area to 10 pixels at z10
    min_area AS (
        SELECT power(pixel_size * 10 AS min_area
        FROM pixel_size
    ),
    -- Filter out polygons smaller than the minimum area
    landuse_filtered AS (
        SELECT id, tags, geom
        FROM osm_landuse
        WHERE st_area(geom) > min_area
    ),
    -- Buffer the landuse polygons
    landuse_buffered AS (
        SELECT id, tags, st_buffer(geom, buffer_distance) AS geom
        FROM landuse_filtered, buffer_distance
    ),
    -- Union the buffered polygons
    landuse_buffered_union AS (
        SELECT st_union(geom) AS geom
        FROM landuse_buffered
    ),
    -- Simplify the unioned polygon
    landuse_simplified AS (
        SELECT st_simplifypreservetopology(geom, 78270 / power(2, 10)) AS geom
        FROM landuse_buffered_union
    )
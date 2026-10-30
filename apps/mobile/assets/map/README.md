# Map styles

`route_preview_style.json` uses OpenStreetMap's public raster tiles for local,
small-scale development previews so the Fake-mode route resembles the React
dashboard. The app displays the required OSM attribution over the map.

Before release, replace this development source with the configured managed
tile provider or PMTiles source from `MAP_TILE_URL` and `MAP_TILE_KEY`. Do not
ship `tile.openstreetmap.org` as the production tile source.

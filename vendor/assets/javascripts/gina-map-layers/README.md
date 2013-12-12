GINA Map Layers Javascript Library
==================================

This project is a library used to inject GINA Map layers into various web map apis.

Examples can be found at http://github.com/gina-alaska/gina-map-layers-examples

Supported Web Map APIs
----------------------

* OpenLayers 2.11
* Google Maps 3
* Bing Maps 6.3, 7.0
* ArcGIS JS API 2.6

Include the library
-------------------

Include the base library and layer definitions for your desired web api,

  OpenLayers: 

    <script src="gina-map-layers/gina-openlayers.js" type="text/javascript"></script>
    
  Google Maps: 

    <script src="gina-map-layers/gina-googlemaps3.js" type="text/javascript"></script>
  
  Bing Maps 6.3
  
    <script src="gina-map-layers/gina-bingmaps63.js" type="text/javascript"></script>
    
  Bing Maps 7.0

    <script src="gina-map-layers/gina-bingmaps7.js" type="text/javascript"></script>
 
  ArcGIS JS API 2.6 

    <script src="gina-map-layers/gina-arcgis26.js" type="text/javascript"></script>    
    
Inject the layers into your map object
--------------------------------------

  This will inject the Spherical Mercator tile projection into your map object  
  
    Gina.Layers.inject(map, 'TILE.EPSG:3857.BDL');
  
  You can also inject multiple layers by providing an array with each layer to add
  
    Gina.Layers.inject(map, ['TILE.EPSG:3857.BDL', 'TILE.EPSG:3857.OSM']);
    
  Limited wildcard support is also available, include all tiles for the spherical mercator projection
  
    Gina.Layers.inject(map, 'TILE.EPSG:3857.*');

  OpenLayers Example:

    <script type="text/javascript" charset="utf-8">
      var map;
      function initialize() {
        map = new OpenLayers.Map("map");

        /* Inject all spherical mercator tile layers into the map */
        Gina.Layers.inject(map, 'TILE.EPSG:3857.*');

        map.addControl(new OpenLayers.Control.LayerSwitcher());
        map.zoomToMaxExtent();        
      }
    </script>
    
Getting a layer object
----------------------

  It is possible to get an object for a specific layer calling the Gina.Layers.get method,
    
  Example getting a reference to the BDL layer:
  
    // Fetch the BDL tile layer object
    var bdl = Gina.Layers.get('TILE.EPSG:3857.BDL');
    // Now manually at the layer to the map
    map.addLayer(bdl);
    
Available Tile Layers
---------------------

  Projection EPSG:3857 - Spherical Mercator (Google, Bing, OpenLayers)

    Layer ID                        Name
    ------------------------------  ---------------------------------
    TILE.EPSG:3857.BDL              GINA Best Data Layer
    TILE.EPSG:3857.TOPO             USGS Topographic DRG
    TILE.EPSG:3857.CHARTS           NOAA Nautical Charts DRG
    TILE.EPSG:3857.SHADED_RELIEF    GINA Shaded Relief (NED)
    TILE.EPSG:3857.LANDSAT_PAN      Panchromatic Landsat
    TILE.EPSG:3857.SDMI_ORTHO_RGB   SDMI Ortho Project Natural Color (Overlay)
    TILE.EPSG:3857.SDMI_ORTHO_CIR   SDMI Ortho Project Color Infrared (Overlay)
    TILE.EPSG:3857.SDMI_ORTHO_GS    SDMI Ortho Project Grayscale (Overlay)
    
  Projection EPSG:3338 - Alaskan Albers (OpenLayers)

    Layer ID                        Name
    ------------------------------  ---------------------------------
    TILE.EPSG:3338.BDL              GINA Best Data Layer
    TILE.EPSG:3338.TOPO             USGS Topographic DRG
    TILE.EPSG:3338.SHADED_RELIEF    GINA Shaded Relief (NED)
    TILE.EPSG:3338.OSM              OpenStreetMaps Base Layer
    TILE.EPSG:3338.OSM_OVERLAY      OpenStreetMaps Roads & Cities (Overlay)
    TILE.EPSG:3338.SDMI_ORTHO_RGB   SDMI Ortho Project Natural Color (Overlay)
    TILE.EPSG:3338.SDMI_ORTHO_CIR   SDMI Ortho Project Color Infrared (Overlay)
    TILE.EPSG:3338.SDMI_ORTHO_GS    SDMI Ortho Project Grayscale (Overlay)
    
  Projection EPSG:3572 - Alaskan Centric Polar Projection (OpenLayers)

    Layer ID                        Name
    ------------------------------  ---------------------------------
    TILE.EPSG:3572.BDL              GINA Best Data Layer
    TILE.EPSG:3572.OSM              OpenStreetMaps Base Layer
    TILE.EPSG:3572.OSM_OVERLAY      OpenStreetMaps Roads & Cities (Overlay)


License
-------

See LICENSE file for licensing and credits.  Think BSD/MIT.

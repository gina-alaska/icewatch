#Based on Extjs-OpenLayers by William Fisher  - @teknofire on Github

$ = jQuery

$.fn.extend
  OpenLayers: (options) ->
    config = 
      map: null,
      layers: null,
      projection: 'EPSG:3338',
      defaultZoom: 2,
      defaultCenter: new OpenLayers.LonLat(-147.849, 64.856)
    
    mapConfig =  {}
        
    projections =        
      # Alaska centric polar projection
      'EPSG:3572': 
        defaultLayers: ['TILE.EPSG:3572.BDL', 'TILE.EPSG:3572.OSM_OVERLAY'],
        minZoomLevel: 2,
        maxExtent: new OpenLayers.Bounds(-12742200.0, -7295308.34278405, 7295308.34278405, 12742200.0),
        maxResolution: (20037508.34278405 / 256.0),
        units: 'm',
        projection: "EPSG:3572",
        displayProjection: new OpenLayers.Projection("EPSG:4326")
      # Alaskan Albers Equal Area
      'EPSG:3338': 
        defaultLayers: ['TILE.EPSG:3338.BDL', 'TILE.EPSG:3338.OSM', 'TILE.EPSG:3338.OSM_OVERLAY'],
        maxExtent: new OpenLayers.Bounds(-3500000, -3500000, 3500000, 3500000),
        maxResolution: (3500000 * 2.0 / 256.0),
        minZoomLevel: 2,
        units: 'm',
        projection: "EPSG:3338",
        displayProjection: new OpenLayers.Projection("EPSG:4326")
      #  TODO find the espg code for the google projections
      'google': 
        defaultLayers: ['TILE.EPSG:3857.BDL', 'TILE.EPSG:3857.OSM', 'TILE.EPSG:3857.TOPO', 'TILE.EPSG:3857.CHARTS', 'TILE.EPSG:3857.OSM_OVERLAY'],
        projection: "EPSG:900913",
        units: 'm',
        maxResolution: 156543.0339,
        maxExtent: new OpenLayers.Bounds(-20037508, -20037508, 20037508, 20037508),
        displayProjection: new OpenLayers.Projection("EPSG:4326")

    setupMap = (options)->
      for el in this
        unless $.data(el, "map") 
          $.extend config, options
          
          mapConfig = $.extend {}, projections[config.projection], config
          
          mapConfig.defaultLayers = config.layers if config.layers 
      
          map = new OpenLayers.Map(el, mapConfig);
          Gina.Layers.inject map, mapConfig.defaultLayers
          
          center = config.defaultCenter.clone();
          center.transform map.displayProjection, map.getProjectionObject();
          map.setCenter center, config.defaultZoom;
          
          map.addControl(new OpenLayers.Control.Attribution);
          
          #TODO: Handle map resizes automatically
                    
          $.data(el, "map", map)
    #setupLayers = (map) ->
      #Gina.Layers.inject map, mapConfig.defaultLayers
    
    methods =
      getmap: ->
        for el in this
          $.data(el, "map")
      
    method = Array.prototype.slice.call(arguments, 0)[0];
    if ( methods[method] )
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    else if ( typeof method is 'object' or ! method )
      return setupMap.apply( this, arguments );
    else
      $.error( 'Method ' +  method + ' does not exist on jQuery.OpenLayers' );
             
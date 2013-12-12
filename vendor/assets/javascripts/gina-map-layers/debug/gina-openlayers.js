/** 
 *  Autogenerated, do not modify this file directly
 **/

/**
 * Geographic Information Network of Alaska
 * GINA Web Layers Javascript Library
 * @author Will Fisher
 **/

(function() {
  var global = this;
  
  if(typeof Gina === 'undefined') {
    global.Gina = {
      "isArray": ('isArray' in Array) ? Array.isArray : function(value) {
        return Object.prototype.toString.call(value) === '[object Array]';
      },
      "isString": function(value) {
        return ((typeof value) === 'string');
      }
    };
  }
  Gina.global = global;
  
  
  Gina.Projections = {
    define: function(name, options){
      Gina.Projections[name] = options;
    },
    get: function(name) {
      if(Gina.Projections[name]) {
        return Gina.Projections[name];        
      } else {
        return Gina.Projections.build(name);
      }
    },
    build: function(name) {
      return false;
    }
  };
  
  Gina.layerHandlers = {};
  
  Gina.Layers = {
    Types: { TILE: 'tile', WMS: 'wms' },
    
    /**
    * Get the map layer object, create it if needed
    **/
    get: function(name, raw){
      var components = name.split('.'), index;
      var layer = Gina.Layers;
      var item;
      
      for(index = 0; index < components.length; index++) {
        item = components[index];
        
        if(!layer[item]) { return null; }
        layer = layer[item];
      }
      
      /* If layer def has a type then run it through the layer builder */
      if(!raw && layer && layer.type && Gina.layerHandlers[layer.type]) {
        return (Gina.layerHandlers[layer.type])(layer, name);
      } else {
        return layer;        
      }
    },
    
    getIDs: function(wild) {
      var components = wild.split('.'), index;
      var layer = Gina.Layers;
      var item, path = [];
      var layerNames = [];
      
      for(index = 0; index < components.length; index++) {
        item = components[index];
        
        if(Gina.Layers.isWildcard(item)) { 
          var baseName = path.join('.');
          for(var name in layer) {
            layerNames.push(baseName + '.' + name);            
          }
        } else {
          path.push(item);
        }
        layer = layer[item];
      }
      
      return layerNames;
    },
    
    /**
    * Define the layer for later use, does not instantiate the apporpriate map layer object
    **/
    define: function(name, params){
      var components = name.split('.'),  
          last = (components.length - 1),
          layer = Gina.Layers,
          type, index;
      
      if(params && params.type) { type = params.type; }
      
      for(index = 0; index < (components.length - 1); index++) {
        var item = components[index];
        
        if(!layer[item]) { layer[item] = {}; }
        layer = layer[item];
      }
      
      layer[components[last]] = params;
      
      return layer;
    },
    
    exists: function(name) {
      return Gina.Layers.get(name) !== null;
    },
    
    isWildcard: function(name) {
      var re = /\*$/;
      return name.match(re);
    },
    
    inject: function(map, layer_names){
      if(Gina.isString(layer_names)) {
        layer_names = [layer_names];
      }
      
      if(Gina.isArray(layer_names)) {
        Gina.Layers.injectEachLayer(map, layer_names);
      } else {
        Gina.Layers.injectLayer(map, layer_names);
      }
    },
    
    injectEachLayer: function(map, layers) {
      for(var ii = 0; ii < layers.length; ii++) {
        if (Gina.isString(layers[ii]) && Gina.Layers.isWildcard(layers[ii])) {
          Gina.Layers.inject(map, Gina.Layers.getIDs(layers[ii]));
        } else {
          Gina.Layers.injectLayer(map, layers[ii]);
        }  
      }
    },
    
    injectLayer: function(map, layer) {
      if(Gina.isString(layer) && Gina.Layers.exists(layer)) {
        Gina.layerHandlers.inject(map, Gina.Layers.get(layer), layer);
      } else {
        Gina.layerHandlers.inject(map, layer);
      }
    }
  };
})();
/** Alaska Albers **/
Gina.Layers.define('TILE.EPSG:3338.BDL', {
  name: 'Best Data Layer',
  type: Gina.Layers.Types.TILE, 
  url: 'http://tiles.gina.alaska.edu/tilesrv/bdl_aa/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true,
    wmsId: 'WMS.BDL'
  }
});

/** Polar Projection **/
Gina.Layers.define('TILE.EPSG:3572.BDL', {
  name: 'Best Data Layer',
  type: Gina.Layers.Types.TILE, 
  url: 'http://tiles.gina.alaska.edu/tilesrv/bdl_3572/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true,
    wmsId: 'WMS.BDL'
  }
});

/** Google Projection **/
Gina.Layers.define('TILE.EPSG:3857.BDL', {
  name: 'Best Data Layer',
  type: Gina.Layers.Types.TILE, 
  url: 'http://tiles.gina.alaska.edu/tilesrv/bdl/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: true,
    visibility: true,
    isBaseLayer: true,
    sphericalMercator: true,
    wmsId: 'WMS.BDL'
  }
});

Gina.Layers.define('WMS.BDL', {
  name: 'Best Data Layer',
  type: Gina.Layers.Types.WMS, 
  url: 'http://wms.alaskamapped.org/bdl',
  wmsOptions: {
    //layers: "bdl_low_full,bdl_low_overview,bdl_mid_res_overview,bdl_mid_res_full,bdl_high_res_full,bdl_high_res_overview",
    layers: "BestDataAvailableLayer",
    transparent: false
  },
  layerOptions: {
    wrapDateLine: false,
    isBaseLayer: true
  }
});
/**
 * Name: TILE.EPSG:3857.CHARTS
 * Projection: EPSG:3857 Google Mercator Projection
 * Nautical Charts in Google Mercator Projection, NOT FOR NAVIGATION
 */
Gina.Layers.define('TILE.EPSG:3857.CHARTS', {
  name: 'Nautical Charts',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tilesrv/charts/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true,
    sphericalMercator: true,
    wmsId: "WMS.CHARTS"
  }
});


Gina.Layers.define('WMS.CHARTS', {
  name: 'NOAA Charts',
  type: Gina.Layers.Types.WMS,
  url: 'http://wms.alaskamapped.org/charts',
  wmsOptions: {
    layers: "NOAA_Charts",
    transparent: false
  },
  layerOptions: {
    wrapDateLine: false,
    isBaseLayer: true
  }
});
/**
 * Name: TILE.EPSG:3857.LANDSAT_PAN
 * Projection: EPSG:3857 Google Mercator Projection
 * Landsat Panchromatic Layer
 */
Gina.Layers.define('TILE.EPSG:3857.LANDSAT_PAN', {
  name: 'Landsat - Panchromatic',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tilesrv/landsat_pan/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true,
    sphericalMercator: true
  }
});
/**
 * Name: TILE.EPSG:3338.OSM
 * Projection: EPSG:3338 Alaskan Albers
 * OpenStreetMap Baselayer in Alaskan Albers Projection
 */
Gina.Layers.define('TILE.EPSG:3338.OSM', {
  name: 'OpenStreetMap',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/test/tilesrv/osm/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true,
    attribution: '(c) <a href="http://www.openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
  }
});

/**
 * Name: TILE.EPSG:3572.OSM_OVERLAY
 * Projection: EPSG:3572 Polar Projection
 * OpenStreetMap overlay in a polar projection
 */
Gina.Layers.define('TILE.EPSG:3572.OSM_OVERLAY', {
  name: 'OpenStreetMap - Roads & Cities',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/test/tilesrv/osm-google-ol-3572/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: false,
    attribution: '(c) <a href="http://www.openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
  }
});

/**
 * Name: TILE.EPSG:3338.OSM_OVERLAY
 * Projection: EPSG:3338 Alaskan Albers
 * OpenStreetMap road and city overlay in Alaskan Albers projection
 */
Gina.Layers.define('TILE.EPSG:3338.OSM_OVERLAY', {
  name: 'OpenStreetMap - Roads & Cities',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/test/tilesrv/osm-google-ol/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: false,
    attribution: '(c) <a href="http://www.openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
  }
});/**
 * Name: TILE.EPSG:3857.SHADEDRELIEF
 * Projection: EPSG:3857 Google Mercator Projection
 * Gray scale shaded relief base layer
 */
Gina.Layers.define('TILE.EPSG:3857.SHADED_RELIEF', {
  name: 'Shaded Relief',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tilesrv/shaded_relief_ned/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true,
    sphericalMercator: true
  }
});

/**
 * Name: TILE.EPSG:3338.SHADEDRELIEF
 * Projection: EPSG:3338 Alaskan Albers
 * Gray scale shaded relief, based on ned and bathymetric data
 */
Gina.Layers.define('TILE.EPSG:3338.SHADED_RELIEF', {
  name: 'Shaded Relief + Bathymetry',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tiles/aea_gina_bathymetry_aa/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true
  }
});
/**
 * Name: TILE.EPSG:3857.SPOT5_RGB
 * Projection: EPSG:3857 Google Mercator
 * Tiles from the SPOT5 SDMI Ortho Project
 */
Gina.Layers.define('TILE.EPSG:3857.SDMI_ORTHO_RGB', {
  name: 'SDMI Ortho Natural Color',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tiles/SPOT5.SDMI.ORTHO_RGB/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: false,
    isBaseLayer: false,
    sphericalMercator: true
  }
});

/**
 * Name: TILE.EPSG:3857.SDMI_ORTHO_CIR
 * Projection: EPSG:3857 Google Mercator
 * Description
 */
Gina.Layers.define('TILE.EPSG:3857.SDMI_ORTHO_CIR', {
  name: 'SDMI Ortho Color Infrared',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tiles/SPOT5.SDMI.ORTHO_CIR/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: false,
    isBaseLayer: false,
    sphericalMercator: true
  }
});

/**
 * Name: TILE.EPSG:3857.SDMI_ORTHO_GS
 * Projection: EPSG:3857 Google Mercator
 * Tiles from the SDMI Ortho Project, Grayscale
 */
Gina.Layers.define('TILE.EPSG:3857.SDMI_ORTHO_GS', {
  name: 'SDMI Ortho Grayscale',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tiles/SPOT5.SDMI.ORTHO_PAN/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: false,
    isBaseLayer: false,
    sphericalMercator: true
  }
});

/**
 * Name: TILE.EPSG:3338.SPOT5_RGB
 * Projection: EPSG:3338 Google Mercator
 * Tiles from the SPOT5 SDMI Ortho Project
 */
Gina.Layers.define('TILE.EPSG:3338.SDMI_ORTHO_RGB', {
  name: 'SDMI Ortho Natural Color',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tiles/SPOT5.SDMI.ORTHO_RGB_aa/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: false,
    isBaseLayer: false
  }
});

/**
 * Name: TILE.EPSG:3338.SDMI_ORTHO_CIR
 * Projection: EPSG:3338 Google Mercator
 * Description
 */
Gina.Layers.define('TILE.EPSG:3338.SDMI_ORTHO_CIR', {
  name: 'SDMI Ortho Color Infrared',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tiles/SPOT5.SDMI.ORTHO_CIR_aa/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: false,
    isBaseLayer: false
  }
});

/**
 * Name: TILE.EPSG:3338.SDMI_ORTHO_GS
 * Projection: EPSG:3338 Google Mercator
 * Tiles from the SDMI Ortho Project, Grayscale
 */
Gina.Layers.define('TILE.EPSG:3338.SDMI_ORTHO_GS', {
  name: 'SDMI Ortho Grayscale',
  type: Gina.Layers.Types.TILE,
  url: 'http://tiles.gina.alaska.edu/tiles/SPOT5.SDMI.ORTHO_PAN_aa/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: false,
    isBaseLayer: false
  }
});/** Alaska Albers **/
Gina.Layers.define('TILE.EPSG:3338.TOPO', {
  name: 'Topographic DRG',
  type: Gina.Layers.Types.TILE, 
  url: 'http://tiles.gina.alaska.edu/tilesrv/drg_shaded_aa/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true,
    wmsId: "WMS.TOPO"
  }
});

/** Google Projection **/
Gina.Layers.define('TILE.EPSG:3857.TOPO', {
  name: 'Topographic DRG',
  type: Gina.Layers.Types.TILE, 
  url: 'http://tiles.gina.alaska.edu/tilesrv/drg/tile/${x}/${y}/${z}',
  layerOptions: {
    type: 'jpeg',
    transitionEffect: 'resize',
    wrapDateLine: false,
    visibility: true,
    isBaseLayer: true,
    sphericalMercator: true,
    wmsId: "WMS.TOPO"
  }
});

Gina.Layers.define('WMS.TOPO', {
  name: 'Topographic DRG',
  type: Gina.Layers.Types.WMS,
  url: 'http://no.gina.alaska.edu/extras',
  wmsOptions: {
    layers: "Hill Shaded DRG",
    transparent: false
  },
  layerOptions: {
    wrapDateLine: false,
    isBaseLayer: true
  }
});
Gina.layerHandlers = {
  inject: function(map, layer) {
    return map.addLayer(layer);
  },
  tile: function(params) {
    return new OpenLayers.Layer.XYZ(params.name, params.url, params.layerOptions);
  },
  wms: function(params) {
    return new OpenLayers.Layer.WMS(
      params.name, params.url, params.wmsOptions, params.layerOptions
    );
  }
};

Gina.Projections.build = function(epsg) {
  var config = Gina.Projections.get('EPSG:3857');
  if(config) {
    var from = new OpenLayers.Projection(config.projection);
    var to = new OpenLayers.Projection(epsg);

    config.projection = epsg;
    config.maxExtent.transform(from, to);
    config.maxResolution = (config.maxExtent.getSize().w * 2 / 256.0);  
    
    return config;        
  }
  
  return null;
};
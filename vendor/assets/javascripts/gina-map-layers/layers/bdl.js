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

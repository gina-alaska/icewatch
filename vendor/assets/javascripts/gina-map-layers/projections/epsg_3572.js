/**
 * Name: Polar Projection
 * EPSG: 3572
 **/
Gina.Projections.define('EPSG:3572', {
  defaultLayers: [
    'TILE.EPSG:3572.BDL', 'TILE.EPSG:3572.OSM', 'TILE.EPSG:3572.TOPO', 'TILE.EPSG:3572.CHARTS', 
    'TILE.EPSG:3572.SHADED_RELIEF', 'TILE.EPSG:3572.OSM_OVERLAY'
  ],
  projection: "EPSG:3572",
  maxResolution: 78271.516964, /* (7295308.34278405-12742200.0) / 256.0) */
  maxExtent: new OpenLayers.Bounds(-12742200.0, -7295308.34278405, 7295308.34278405, 12742200.0),
  units: 'm'
});

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

Gina.layerHandlers = {
  inject: function(map, layer, id) {
    if(id) {
      if(Gina.Layers.get(id, true).layerOptions.isBaseLayer) {
        map.mapTypes.set(id, layer);      
      } else if(Gina.Layers.get(id, true).layerOptions.visibility) {
        map.overlayMapTypes.insertAt(0, layer);                    
      }      
    } else {
      map.overlayMapTypes.insertAt(0, layer);      
    }
  },
  tile: function(params) {
    params.getTileUrl = function(coord, zoom) {
      var tiles = 1 << zoom, x = (coord.x % tiles);
      if(x < 0) { x += tiles; }
      
      var url = params.url;
      url = url.replace('${x}', x);
      url = url.replace('${y}', coord.y);
      url = url.replace('${z}', zoom);
      
      return url + '.png';
    };
    
    params.alt = params.name;
    params.minZoom = 1;
    params.maxZoom = 21;
    params.tileSize = new google.maps.Size(256,256);
    params.isPng = true;
    
    return new google.maps.ImageMapType(params);
  }
};
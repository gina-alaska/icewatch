Gina.layerHandlers = {
  inject: function(map, layer, id) {
    // Push the tile layer to the map
    map.entities.push(layer);
  },
  
  tile: function(params, id) {
    var getTilePath = function(tile) {
      var url = params.url;
      url = url.replace('${x}', tile.x);
      url = url.replace('${y}', tile.y);
      url = url.replace('${z}', tile.levelOfDetail);
      
      return url + ".png"
    }
    
    var tileSource = new Microsoft.Maps.TileSource({ uriConstructor: getTilePath });
    // Construct the layer using the tile source
    var tilelayer = new Microsoft.Maps.TileLayer({ mercator: tileSource, opacity: 1 });
    
    return tilelayer;
  }
}
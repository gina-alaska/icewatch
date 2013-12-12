Gina.layerHandlers = {
  inject: function(map, layer, id) {
    // Push the tile layer to the map
    map.AddTileLayer(layer);
  },
  
  tile: function(params, id) {
    var tileSourceSpec = new VETileSourceSpecification(id, '');
    tileSourceSpec.GetTilePath = function(tileContext) {
      var url = params.url;
      url = url.replace('${x}', tileContext.XPos);
      url = url.replace('${y}', tileContext.YPos);
      url = url.replace('${z}', tileContext.ZoomLevel);
      
      return url + ".png"
    }
    // tileSourceSpec.MinZoomLevel = minlvl;
    // tileSourceSpec.MaxZoomLevel = maxlvl;
    // tileSourceSpec.Opacity = opac;
    return tileSourceSpec;
  }
}
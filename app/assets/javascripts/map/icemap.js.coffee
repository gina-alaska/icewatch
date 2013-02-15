class @IceMap
  init: (div="#map") ->
    return if $(div).length == 0
    @datasource = $(div).attr('data-url');
    @div = $(div);
    @div.OpenLayers
      units: 'm',
      projection: "EPSG:3572",
      displayProjection: new OpenLayers.Projection("EPSG:4326"),
      defaultCenter: new OpenLayers.LonLat(-147.849, 80.856)
    
    
    @map = @div.OpenLayers('getmap')[0];
    @map.zoomTo(3);     

    trackLayer = new OpenLayers.Layer.Vector("track", {
      styleMap: new OpenLayers.StyleMap({
        pointRadius: "${total_concentration}"
        fillColor: "${color}"
      })
    });
    parser = new OpenLayers.Format.GeoJSON;
    $.getJSON @datasource, (data) =>
      features = parser.read(data);
      for feature in features
        feature.geometry.transform(@map.displayProjection, @map.getProjectionObject());

      trackLayer.addFeatures(features);
    
    @map.addLayer(trackLayer);

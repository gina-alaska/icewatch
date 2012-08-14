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
    
    #Gina.Layers.inject(map, 'TILE.EPSG:3572.*');
    
    @map.zoomTo(3);     

    console.log("Adding layers from ", @datasource)

    trackLayer = new OpenLayers.Layer.Vector("track");
    parser = new OpenLayers.Format.GeoJSON;
    $.getJSON @datasource, (data) =>
      $.each data, (index,point) =>
        feature = parser.parseFeature(point.location);
        feature.geometry.transform(@map.displayProjection, @map.getProjectionObject());
        trackLayer.addFeatures(feature);
    
    @map.addLayer(trackLayer);

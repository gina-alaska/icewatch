class @IceMap
  init: (div="#map-container") ->
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
    
  getMap: -> 
    @map

  addCruise: (url) ->
    layer = new OpenLayers.Layer.Vector "track",
      styleMap: new OpenLayers.StyleMap
        fillColor: "${color}",
        pointRadius: 10
    @fetchFeatures layer, url
  #end
    
  addTrack: (url) ->
    layer = new OpenLayers.Layer.Vector "track", 
      styleMap: new OpenLayers.StyleMap
        pointRadius: "${total_concentration}"
        fillColor: "${color}"

    @fetchFeatures layer, url
  #end
  
  fetchFeatures: (layer, url) ->
    parser = new OpenLayers.Format.GeoJSON; 
    
    $.getJSON url, (data) =>
      
      color = nv.utils.getColor(d3_icewatch_cruise)
      
      features = parser.read(data);
      for feature, i in features
        feature.attributes.color = color(feature.attributes, i)
        feature.geometry.transform(@map.displayProjection, @map.getProjectionObject());
    
      layer.addFeatures(features);
    #end getJSON
     
    @map.addLayer(layer)
  #end 
    
  addAmsrData: (layer) ->
    @amsrLayer = new OpenLayers.Layer.WMS "Shire", "http://shire.gina.alaska.edu", {
      layers: layer
    },{
      isBaseLayer: false,
      singleTile: true
    }
    
    @map.addLayer(@amsrLayer)
  #end addAmsrData
    
  # selectControl = new OpenLayers.Control.SelectFeature map.trackLayer,
  #   hover: false,
  #   clickOut: true,
  #   onSelect: (feature) ->
  #     $("#cruise-info").load "#{cruises_path}/" + feature.attributes.cruise_id, ->
  #       console.log("Done!")       
  # 
  #   eventListeners: 
  #     featurehighlighted: (feature) ->
  # 
  # map.getMap().addControl(selectControl)
  # selectControl.activate();

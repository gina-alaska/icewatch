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
        default: 
          fillColor: "#DDDDDD",
          strokeColor: "${color}",
          pointRadius: 3
        select:
          fillColor: "#DDDDDD",
          strokeColor: "${color}",
          pointRadius: 10
        
    highlightControl = new OpenLayers.Control.SelectFeature layer,
      hover: true,
      highlightOnly: true,
      eventListeners: 
        featurehighlighted: (e) ->
          feature = e.feature
          $("#highlighted-cruise p").text($("##{feature.attributes.cruise_id}").text()).show()  
        featureunhighlighted: (e) ->
          $("#highlighted-cruise p").fadeOut 1500, ->
            $(@).text ""
   
    selectControl = new OpenLayers.Control.SelectFeature layer,
      hover: false,
      onSelect: (feature) ->
        if feature.attributes.cruise_id?
          window.location = $("##{feature.attributes.cruise_id}").attr('href')
          
    
    @map.addControl(highlightControl)
    @map.addControl(selectControl)
    
    highlightControl.activate();
    selectControl.activate();

      
    @fetchFeatures layer, url
  #end
    
  addTrack: (url) ->
    layer = new OpenLayers.Layer.Vector "track", 
      styleMap: new OpenLayers.StyleMap
        default: 
          pointRadius: "${total_concentration}"
          fillColor: "${color}"
        select: 
          pointRadius: 15,
          fillColor: "${color}"
          
    selectControl = new OpenLayers.Control.SelectFeature layer,
      hover: true,
      clickOut: true,
      onSelect: (feature) ->
        $("#obs-data tr.success").removeClass("success")
        o = $("#obs-data").dataTable()
        nodes = o.fnGetNodes()
        row = $(nodes).filter("##{feature.attributes.observation_id}")[0]
        $(row).addClass("success")
        page = Math.floor(o.fnGetPosition(row) / o.fnSettings()._iDisplayLength)
        o.fnPageChange(page)

    @map.addControl(selectControl)
    selectControl.activate();
    
    
    @fetchFeatures layer, url
  #end
  
  fetchFeatures: (layer, url) ->
    parser = new OpenLayers.Format.GeoJSON; 
    
    $.getJSON url, (data) =>
      color = nv.utils.getColor(d3_icewatch_cruise)
      cruiseColors = {};
      features = parser.read(data);

      for feature, i in features
        if !feature.attributes.color
          unless cruiseColors[feature.attributes.cruise_id]
            cruiseColors[feature.attributes.cruise_id] = color(feature.attributes, i)
        
          feature.attributes.color = cruiseColors[feature.attributes.cruise_id]
        
        feature.geometry.transform(@map.displayProjection, @map.getProjectionObject());
    
      layer.addFeatures(features);
      @map.zoomToExtent(layer.getDataExtent())
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

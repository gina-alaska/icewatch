// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require gina-map-layers/gina-openlayers
//= require d3.v2
//= require rickshaw/rickshaw
//= require jquery-file-upload/js/vendor/jquery.ui.widget
//= require jquery-file-upload/js/jquery.iframe-transport
//= require jquery-file-upload/js/jquery.fileupload
//= require datatables/media/js/jquery.dataTables
//=# require jquery-ui/jquery-ui-1.8.21.custom.min
//= require_tree ./map

$(document).ready(function() {
  $("#map").OpenLayers({
    units: 'm',
    projection: "EPSG:3572",
    displayProjection: new OpenLayers.Projection("EPSG:4326"),
    defaultCenter: new OpenLayers.LonLat(-147.849, 80.856) 
  });

  var map = $("#map").OpenLayers('getmap')[0];

  //Gina.Layers.inject(map, 'TILE.EPSG:3572.*');

  map.zoomTo(3);     

  var style = new OpenLayers.Style({

  },{})

  var trackLayer = new OpenLayers.Layer.Vector("track");
  var parser = new OpenLayers.Format.GeoJSON;
  $.getJSON("/observations.json", function(data) {
    $.each(data, function(index,point){
      var feature = parser.parseFeature(point.location);
      feature.geometry.transform(map.displayProjection, map.getProjectionObject());
      trackLayer.addFeatures(feature);
    })
  });

  map.addLayer(trackLayer);

  var i = new IceGraph;
  i.init();

});
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  crs = new L.Proj.CRS('EPSG:3572','+proj=laea +lat_0=90 +lon_0=-150 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs', {
    resolutions: [32768, 16384, 8192, 4096, 2048, 1024, 512, 256, 128,64, 32, 16, 8, 4, 2, 1, 0.5]
    transformation: new L.Transformation(1, -9020047.848073645, -1, 9020047.848073645)
  })

  return if $('#map').length == 0

  map = new L.Map 'map',
  	crs: crs,
  	continuousWorld: true

  L.tileLayer.wms('http://wms.alaskamapped.org/bdl/',
    layers: 'BestDataAvailableLayer'
    format: 'image/jpeg'
    continuousWorld: true).addTo(map)

  dataUrl = $("#map").data('cruise-info')

  $.getJSON dataUrl, (data) =>
    L.geoJson(data,
      pointToLayer: (feature, latlng) ->
        markerOptions =
          radius: feature.properties.iceConcentration
          # fillColor: feature.properties.fillColor
          className: "#{feature.properties.dominantIceType}-ice"
          color: '#000'
          fillOpacity: 1
        L.circleMarker(latlng, markerOptions)
    ).addTo(map)
  map.setView [80.856,-147.849], 3

$(document).on 'change.bs.fileinput', '.cruise-upload', (event) ->
  $(this).find('input[type=file]').parse
    config:
      header: true
      skipEmptyLines: true
      dynamicTypeing: true
      complete: (results) =>
        url = $(this).find('input[type=file]').data('submit-url')
        uploader = new ObsUploader url, results.data
        uploader.submitNextRow()
        $(this).fileinput('clear')

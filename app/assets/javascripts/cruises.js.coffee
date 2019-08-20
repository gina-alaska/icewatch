# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready turbolinks:load', ->
  crs = new L.Proj.CRS('EPSG:3572',
	 '+proj=laea +lat_0=90 +lon_0=-150 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs',
  		resolutions: [
  			32768, 16384, 8192, 4096, 2048, 1024, 512, 256, 128,
  			64, 32, 16, 8, 4, 2, 1, 0.5
  		],
  		transformation: new L.Transformation(1, -9020047.848073645, -1, 9020047.848073645))

  return if $('#map').length == 0

  map = new L.Map 'map',
  	crs: crs,
  	continuousWorld: true
  map.setView [80.856,-147.849], 3

  L.tileLayer.wms('http://tiles.gina.alaska.edu/tilesrv/drg/tile/{x}/{y}/{z}.png?GOGC=220EAC1F05E4,
    layers: 'BestDataAvailableLayer'
    format: 'image/jpeg'
    continuousWorld: true).addTo(map)

  # L.tileLayer.wms('http://nsidc.org/cgi-bin/atlas_north',
  #   layers: 'sea_ice_concentration_09'
  #   transparent: true
  #   format: 'image/gif'
  #   continuousWorld: true
  #   version: '1.1.1'
  #   attributution: '&copy; <a href="http://nsidc.org">NSIDC</a>').addTo(map)
  cruiseLayer = L.featureGroup().addTo(map)

  $("#map > layer").each (index, layer) ->
    url = $(layer).data('url')
    $.getJSON url, (data) =>
      layer = L.geoJson(data,
        pointToLayer: (feature, latlng) ->
          markerOptions =
            radius: feature.properties.iceConcentration
            className: "#{feature.properties.dominantIceType}-ice"
            color: '#000'
            fillOpacity: 1
          L.circleMarker(latlng, markerOptions)
      )
      cruiseLayer.addLayer(layer)
      map.fitBounds(cruiseLayer.getBounds())

$(document).on 'change.bs.fileinput', '.cruise-upload', (event) ->
  $(this).find('input[type=file]').parse
    config:
      header: true
      skipEmptyLines: true
      dynamicTypeing: true
      complete: (results) =>
        url = $(this).find('input[type=file]').data('submit-url')
        uploader = new ObsUploader url, results.data
        #uploader.submitNextRow()
        $(this).fileinput('clear')

$(document).on 'click', '#all-export', ->
  $(".export[type='checkbox']").prop("checked", true)
$(document).on 'click', '#none-export', ->
  $(".export[type='checkbox']").prop("checked", false)

$(document).on 'click', '.selected-export', (e) ->
  e.preventDefault()

  params = ""
  $(".export[type='checkbox']:checked").each (index, item) ->
    params += "&" unless index is 0
    params += "observations[]=#{$(item).val()}"
  params = "observations[]=#{null}" if params is ""

  joiner = if $(this).attr('href').indexOf('?') is -1 then "?" else "&"
  document.location = "#{$(this).attr('href')}#{joiner}#{params}"

$(document).on 'click', '#sigrid-data-submit', (e) ->
  e.preventDefault()
  $("#sigrid-form").submit()

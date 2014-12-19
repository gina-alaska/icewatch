# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.fileinput').on 'change.bs.fileinput', (event) ->
    console.log(event)
    $(this).find('input[type=file]').parse
      config:
        header: true
        skipEmptyLines: true
        dynamicTypeing: true
        complete: (results) ->
          $('#obs-upload-complete').text(JSON.stringify(results.data))

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change.bs.fileinput', '.cruise-upload.fileinput', (event) ->
    $(this).find('input[type=file]').parse
      config:
        header: true
        skipEmptyLines: true
        dynamicTypeing: true
        complete: (results) =>
          url = $(this).find('input[type=file]').data('submit-url')
          $('#record-count').text("Found #{results.data.length} possible observations")

          submitNextRow(url, results.data)

          $(this).fileinput('reset')



submitNextRow = (url, data) ->
  return unless data.length > 0
  row = data.shift()
  console.log(row)
  $.ajax url,
    type: 'POST'
    contentType: 'application/json'
    dataType: 'json'
    data: JSON.stringify(
      observation: row
    )
    complete: -> submitNextRow(url, data)

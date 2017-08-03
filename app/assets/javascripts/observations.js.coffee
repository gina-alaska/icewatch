# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'keypress keyup keydown', 'form input[type="text"]', (event) ->
  if event.keyCode is 13
    event.preventDefault()
    return false

$(document).on 'ready turbolinks:load', ->
  $("select:not(.person-field)").selectize
    allowEmptyOption: true

  $(".person-field").selectize
    plugins: ['restore_on_backspace', 'remove_button']
    create: (input) ->
      value: input,
      text: input

  $(".datetimepicker").datetimepicker()

$(document).on 'blur', "[data-constraint=integer]", ->
  val = parseFloat($(this).val())
  $(this).val(Math.round(val))


$(document).on 'blur', '.coordinate', ->
  coordinates = $(this).val()
  dms = parseCoordinate(coordinates)
  #If the coordinates change, they input dms
    #Update the value
    #Show help text with the dms value
  #If they didn't change
    #The value is in dd and can be submitted
    #OR The value is invalid and rails will show it as invalid

  if dms != coordinates
    $(this).val(dms)
    $(this).siblings('.help-block').text("#{coordinateType(coordinates)}: #{coordinates}")


@coordinateType = (coordinate) ->
  switch
    when coordinate.match(/^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\s[0-9]{1,2})?(\s?[NSEW])?$/)
      'DMS'
    when coordinate.match(/^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\.[0-9]{1,3})?(\s?[NSEW])?$/)
      'DDM'
    else
      ''


@parseCoordinate = (coordinate) ->

  toDDfromDMS = (value) ->
    dms = value.split " "
    deg = parseFloat dms[0]
    min = parseInt dms[1]
    sec = if dms.length > 2 then parseInt(dms[2]) else 0

    dec = (min * 60 + sec) / 3600.0
    dd = if deg > 0 then deg + dec else deg - dec
    "#{dd.toFixed(4)}"

  toDDfromDDM = (value) ->
    ddm = value.split " "
    deg = parseInt ddm[0]
    min = parseFloat ddm[1]

    dec = min / 60.0
    dd = if deg > 0 then deg + dec else deg - dec
    "#{dd.toFixed(4)}"

  toDMS = (value) ->
    c = parseFloat(value)
    deg = if c < 0 then Math.ceil(c) else Math.floor(c)
    ms = Math.abs(c - deg) * 60.0
    min = Math.floor(ms)
    sec = (ms % 1) * 60.0
    "#{deg} #{min} #{Math.round(sec)}"



  switch coordinateType(coordinate)
    when 'DMS' #coordinate.match(/^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\s[0-9]{1,2})?(\s?[NSEW])?$/)
      toDDfromDMS(coordinate)
    when 'DDM' #coordinate.match(/^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\.[0-9]{1,3})?(\s?[NSEW])?$/)
      toDDfromDDM(coordinate)
    else
      coordinate


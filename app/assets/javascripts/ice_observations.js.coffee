# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'change', '#observation_ice_attributes_total_concentration', ->
  $('select.partial-concentration').siblings('.help-block').text("Total Concentration: #{$(this).val()}/10")

  tc = parseInt($(this).val())
  concentrationOptions = $(this).data('selectize').options


  $("select.partial-concentration").each (idx, pc) ->
    data = $(pc).data('selectize')
    for key, opt of concentrationOptions
      if parseInt(opt.value) > tc then data.removeOption(opt.value) else data.addOption(opt)

@handleIceType = ->
  iceCodes = $(this).data('ice-codes')
  
  disableField = (field) ->
    if $(field).data('selectize') isnt undefined
      $(field).data('selectize').setValue(null)
      $(field).data('selectize').disable()
      $(field).attr('readonly', true).removeAttr('disabled')

    else
      $(field).attr('disabled', true).val('')

  enableField = (field) ->
    if $(field).data('selectize') isnt undefined
      $(field).data('selectize').enable()
    else
      $(field).removeAttr('readonly').removeAttr('disabled')

  selectedValue = parseInt($(this).find('option:selected').val())
  group = $(this).parents('.fields')

  switch
    when iceCodes.indexOf(selectedValue) >= 0
      $(group).find('.floe-size').each (idx, el) ->
          disableField(el)
    else
      $(group).find('.floe-size').each (idx, el) ->
          enableField(el)

$(document).on 'change', '.ice-type', handleIceType
$(document).on 'ready turbolinks:load', ->
  $("select.ice-type").trigger('change')


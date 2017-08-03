# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@handleTopographies = ->
  disableField = (field) ->
    if $(field).data('selectize') isnt undefined
      $(field).data('selectize').clear()
      $(field).data('selectize').disable()
    else if $(field).hasClass('ridge') and $(field).attr('type') is 'checkbox'
      # $(field).bootstrapSwitch('indeterminate', true)
      # $(field).bootstrapSwitch('disabled', true)
    else
      $(field).attr('disabled', true).val(null)

  enableField = (field) ->
    if $(field).data('selectize') isnt undefined
      $(field).data('selectize').enable()
    else if $(field).hasClass('ridge') and $(field).attr('type') is 'checkbox'
      # $(field).bootstrapSwitch('disabled', false)
    else
      $(field).removeAttr('disabled')


  group = $(this).parents('.topography-group')
  selectedValue = parseInt($(this).find('option:selected').val())

  switch
    when  $(this).data('concentration').indexOf(selectedValue) >= 0
      # Enable concentration
      # Disable all others
      enableField($(group).find(".concentration"))
      $(group).find(".ridge").each (idx, el) ->
        disableField(el)
    when $(this).data('ridge').indexOf(selectedValue) >= 0
      # Enable all fields
      $(group).find('.ridge,.concentration').each (idx, el) ->
        enableField(el)
    else
      # Disable all fields
      $(group).find('.ridge,.concentration').each (idx, el) ->
        disableField(el)

$(document).on 'change', '.topography', handleTopographies
$(document).on 'ready turbolinks:load', ->
  $("select.topography").trigger('change')
  # $(".ridge[type='checkbox']").bootstrapSwitch();
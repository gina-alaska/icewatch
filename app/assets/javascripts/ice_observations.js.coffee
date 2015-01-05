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


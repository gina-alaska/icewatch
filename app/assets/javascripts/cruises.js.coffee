# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->
  # $(".obs-upload").fileupload
  #   dataType: "json",
  #   done: (e,data) ->
  #     console.log(e,data,arguments);  
  #     $(data.result.cruise['_id']).html("WAHOO");
  #   add: (e,data) ->
  #     console.log("FOO!")
  #     $(data).submit();
  $(".obs-upload").fileupload
    datatype: "html"
    add: (e,data) ->
      $("#import-modal").modal('show')
      $(data).submit()
    done: (e,data) ->
      $("#import-modal .modal-body").html(data.result)
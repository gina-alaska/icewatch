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
//= require twitter/bootstrap
//= require bootstrap-datepicker
//= require jquery-file-upload/js/vendor/jquery.ui.widget
//= require jquery-file-upload/js/jquery.iframe-transport
//= require jquery-file-upload/js/jquery.fileupload
//= require datatables/media/js/jquery.dataTables
//= require cruises
//= require jquery.pjax

$(document).ready(function() {
  $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('#content');
  $(".datefield").datepicker({"format": "yyyy-mm-dd", "autoclose": true});
  
  $('body').on('click', '.btn[data-form]', function() {
    var form_id = $(this).attr('data-form');
    $("#" + form_id).find('input[type=file]').trigger('click');
  });
});
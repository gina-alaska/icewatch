$(document).ready(function() {
  $(".datefield").datepicker();
  
  
  $("#new_cruise").on("ajax:success", function(e,data) {
    $("#cruises").append(data);
  });
  

  // $(".pending").dataTable({
  //   "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
  //   //"sScrollY": "300px",
  //   "bPaginate": true,
  //   sPaginationType: 'bootstrap',
  //   bScrollCollapse: true
  // });
});
$(document).on 'change.bs.fileinput', '#upload-data-fields', (event) ->
  fileinput = $(event.target).find('input[type=file]').get(0)
  if fileinput.files.length > 0
    fileSize = fileinput.files[0].size;
    if fileSize > 102400000
      $("#upload-submit").prop('disabled', true)
      $("#upload-data #size-warning").removeClass('hide')
    else
      $("#upload-submit").prop('disabled', false)
      $("#upload-data #size-warning").addClass('hide')

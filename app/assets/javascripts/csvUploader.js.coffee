class @ObsUploader

  constructor: (@url, @data, @options = {}) ->
    @recordCount = @data.length
    @createProgressBar()
    # submitNextRow()
    
  submitNextRow: ->
    if @data.length <= 0
      $(".progress-bar").removeClass('active progress-bar-striped')
        .addClass('progress-bar-success')
      $("#modal-close-btn").removeClass('disabled')
      
      return

    row = @data.shift()
    $.ajax @url,
      type: 'POST'
      contentType: 'application/json'
      dataType: 'script'
      data: JSON.stringify
        observation: row
      error: (xhr, status, error) =>
        errors = JSON.parse(xhr.responseText)
        $("#modal-close-btn").removeClass('disabled')
        $("#upload-modal .modal-body").empty().append """
                                                        <h4>The following errors occured:</h4>
                                                      """
        for error in errors
          do (error) ->
            $("#upload-modal .modal-body").append """
                                                    <div class='alert alert-danger'>
                                                      #{error}
                                                    </div>
                                                  """

      success: (data, status, xhr) =>
      
        @updateProgressBar()
        if @data.length == 1
          $.ajax @url + '_follow_up' ,
            type: 'POST'
            contentType: 'application/json'
            dataType: 'script'
            data: JSON.stringify
              observation: row
        
        @submitNextRow()

  updateProgressBar: ->
    pct = ((@recordCount - @data.length) / @recordCount) * 100
    $(@progressModal).find('.progress-bar').attr('style', "width: #{pct}%")

  createProgressBar: ->
    progressModalHTML ="""
                       <div class="modal fade" id="upload-modal">
                         <div class="modal-dialog">
                           <div class="modal-content">
                             <div class="modal-header"><h4>Uploading Observations</h4></div>
                             <div class="modal-body">
                               <div id="#upload-progress" class="progress">
                                 <div class="progress-bar progress-bar-striped active" style="width: 0%"></div>
                               </div>
                             </div>
                             <div class="modal-footer">
                               <div id="modal-close-btn" class="btn btn-primary disabled" data-dismiss="modal">Close</div>
                             </div>
                           </div>
                         </div>
                       </div>
                       """
    @progressModal = $(progressModalHTML)
      .on 'shown.bs.modal', =>
        this.submitNextRow()
      .on 'hidden', ->
        $(this).remove()
      .modal('show')

class @ObsUploader

  constructor: (@url, @data, @options = {}) ->
    @recordCount = @data.length
    @createProgressBar()
    # submitNextRow()

  submitNextRow: ->
    if @data.length <= 0
      @progressModal.modal('hide')
      return
      #return unless @data.length > 0

    row = @data.shift()
    $.ajax @url,
      type: 'POST'
      contentType: 'application/json'
      dataType: 'json'
      data: JSON.stringify
        observation: row
      complete: =>
        @updateProgressBar()
        @submitNextRow()

  updateProgressBar: ->
    pct = ((@recordCount - @data.length) / @recordCount) * 100
    $(@progressModal).find('.progress-bar').attr('style', "width: #{pct}%")

  createProgressBar: ->
    progressModalHTML ="""
                       <div class="modal fade">
                         <div class="modal-dialog">
                           <div class="modal-content">
                             <div class="modal-header"><h4>Uploading Observations</h4></div>
                             <div class="modal-body">
                               <div id="#upload-progress" class="progress">
                                 <div class="progress-bar progress-bar-striped active" style="width: 0%"></div>
                               </div>
                             </div>
                           </div>
                         </div>
                       </div>
                       """
    @progressModal = $(progressModalHTML).modal('show').on 'hidden', ->
      $(this).remove()

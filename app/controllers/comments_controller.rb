class CommentsController < ApplicationController
  respond_to :js
  before_action :set_comment, only: [:update, :destroy]
  # POST /comments
  # POST /comments.json
  def new
    @observation = Observation.find(params[:observation_id])
    @comment = @observation.comments.build

    respond_to do |format|
      format.js { render :new }
    end
  end

  def edit
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.js { render :edit }
    end
  end

  def create
    @observation = Observation.find(params[:observation_id])
    @comment = @observation.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.js { render @comment, layout: false }
      else
        format.js { render 'comment_error', layout: false }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @observation = Observation.find(params[:observation_id])
    @comment = @observation.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.js { render @comment, layout: false }
      else
        format.js { render 'comment_error', layout: false }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:text, :person_id_or_name, :observation_id)
  end
end

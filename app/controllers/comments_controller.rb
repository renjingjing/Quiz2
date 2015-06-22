class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_comment, only: [:destroy]
  before_action :authorize, only: [:destroy]

  def create
    @myidea        = Myidea.find params[:myidea_id]
    comment_params    = params.require(:comment).permit(:body)
    @comment          = Comment.new comment_params
    # associating the @comment with @myidea by assigning the myidea property
    # which came from the `blongs_to` method to @myidea
    # You can also do:
    # @comment.myidea_id = @myidea.id
    # although the method below is preferred:
    @comment.myidea = @myidea
    @comment.user     = current_user
    if @comment.save
      redirect_to myidea_path(@myidea), notice: "comment created"
    else
      # we use the full path because if we do render :show it will look for
      # a template called show.html.erb within the /app/views/comments folder
      render "/myideas/show"
    end
  end

  def destroy
    myidea = Myidea.find params[:myidea_id]
    # comment   = Comment.find params[:id]
    @comment.destroy
    redirect_to myidea_path(myidea), notice: "comment deleted"
  end

  private

  def find_comment
    @comment = Comment.find params[:id]
  end

  def authorize
    # we only allow the comment owner or the comment myidea's owner to delete
    # the comment
    unless can? :manage, @comment
      redirect_to root_path, alert: "Access denied"
    end
  end


end

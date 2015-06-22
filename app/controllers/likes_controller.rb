class LikesController < ApplicationController

before_action :authenticate_user!
before_action :find_myidea

def index
  @users = @myidea.liking_users
end

def create
  @like          = Like.new
  @like.user     = current_user
  @like.myidea = @myidea
  if @like.save
    redirect_to myidea_path(@myidea), notice: "liked"
  else
    redirect_to myidea_path(@myidea), alert: "Can't like"
  end
end

def destroy
  # this will be insecure because anyone can remove someone else's like
  # @like     = Like.find params[:id]

  # @like   = current_user.likes.find(params[:id])
  @like     = @myidea.like_for(current_user)
  @like.destroy
  redirect_to myidea_path(@myidea), notice: "Un-Liked"
end

private

def find_myidea
  @myidea = Myidea.find params[:myidea_id]
end


end

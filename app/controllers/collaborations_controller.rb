class CollaborationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_myidea

  def index
    @users = @myidea.collaborating_users
    redirect_to root_path(@users)
  end

  def create
    @collaboration          = Collaboration.new
    @collaboration.user     = current_user
    @collaboration.myidea = @myidea
    if @collaboration.save
      redirect_to myidea_path(@myidea), notice: "Joined"
    else
      redirect_to myidea_path(@myidea), alert: "Can't join"
    end
  end


  def destroy
    # this will be insecure because anyone can remove someone else's collaboration
    # @collaboration     = Like.find params[:id]

    # @collaboration   = current_user.likes.find(params[:id])
    @collaboration     = @myidea.collaborate_for(current_user)
    @collaboration.destroy
    redirect_to myidea_path(@myidea), notice: "Un-Joined"
  end

  private

  def find_myidea
    @myidea = Myidea.find params[:myidea_id]
  end

end

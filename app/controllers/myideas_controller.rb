class MyideasController < ApplicationController

before_action :find_myidea, only: [:edit, :update, :destroy, :show]
# this before_action will redirect the user to the sign in page unless
# they are signed in already. The exception will be the index and show actions
# because we want them to be publicly available
before_action :authenticate_user!, except: [:index, :show]

#before_action :authorize, only: [:edit, :update, :destroy]

# This action is to list all the myideas in our database.
# We access it with GET request to "/myideas"
def index
  # the page and per methods are from the Kaminari gem which allows
  # to do pagination within the database
  @myideas = Myidea.page(params[:page]).per(10)
end

# the new action is generally used to display the form to create the record
# in this case. The new action displays the form to create a myidea.
def new
  # defining an new Myidea instnace variable to help us generate the
  # form needed to create the myidea
  @myidea = Myidea.new
  # This will render app/views/myideas/new.html.erb (by convention)
end

def create
  # myidea_params in here is a private method that utializes strong params
  @myidea       = Myidea.new(myidea_params)

  @myidea.user  = current_user
  # the myidea.save will return true if it passes validations and saves
  # correctly to the database. Otherwise, it will return false.
  if @myidea.save
    # redirect_to sends a response back to the browser with a new url so the
    # browser can make a new GET request to that URL
    # redirect_to(myidea_path(id: @myidea.id))
    redirect_to myidea_path(@myidea), notice: "Myidea Created"
  else
    # this will render "new.html.erb" inside of "/views/myideas/" folder
    render :new
  end

  # this is just to show on the page the params we get from the user
  # for testing purposes
  # render text: params[:myidea]
end

# you access this action by visiting /myideas/:id
# where :id is the id of the myidea we'd like to display
def show
  # instantiating an empty comment object to help us build the comment form
  @comment = Comment.new

  # this is the like object for the @myidea with current_user
  # so if the user has liked this myidea the `@like` object will exist
  # otherwise the @like object will be nil
  @like      = @myidea.like_for(current_user)
  @collaboration      = @myidea.collaborate_for(current_user)
end

# this is used to render a page that will edit an existing record in
# the database. The URL for it will be /myideas/:id/edit
def edit
  redirect_to root_path, alert: "access denied" unless can? :edit, @myidea
end

def update
  redirect_to root_path, alert: "access denied" unless can? :edit, @myidea
  # if the record updates successfully we redirect the user to the
  # myidea show page.
  if @myidea.update(myidea_params)
    redirect_to myidea_path(@myidea), notice: "Myidea Updated"
  else
    # we render the edit page again with errors if the user doesn't enter
    # values that pass validations
    render :edit
  end
end

def destroy
  redirect_to root_path, alert: "access denied" unless can? :manage, @myidea
  @myidea.destroy
  redirect_to myideas_path, notice: "Myidea Destroyed"
end

private

def find_myidea
  @myidea = Myidea.find params[:id]
end

def myidea_params
  # params[:myidea] => {"title"=>"My first myidea", "body"=>"My first myidea body"}

  # This uses Strong Paramters feature of Rails where you must explicit by
  # default about what parameters you'd like to allow for your record
  # in this case we only want the user to enter teh title and the body
  params.require(:myidea).permit([:title, :body,{collaborating_user_ids: []}])
end

end

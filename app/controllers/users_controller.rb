class UsersController < ApplicationController
  def new
  	@title = "Sign up"
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.name #HTML escaped by default to prevent XSS attacks
  end

end

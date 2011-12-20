class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end
  
  def new
  	@user = User.new
  	@title = "Sign up"
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.name #HTML escaped by default to prevent XSS attacks
  end

  def create
  	@user = User.new(params[:user])
  	
  	if @user.save
          sign_in @user
  	  redirect_to @user, :flash => {:success => "Welcome to the Sample App!"}
  	else	
  	  @title = 'Sign up'
  	  render 'new'
  	end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit User" 
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => {:success => "User Successfully updated!"}
    else
      @title = "Edit User"
      render 'edit'
    end 
  end
  
  def destroy
    @user.destroy
    redirect_to users_path, :flash => {:success => "User destroyed."}
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) 
    end
    
    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if (!current_user.admin? || current_user?(@user))
    end
    
    def current_user?(user)
      current_user == user
    end
    
end

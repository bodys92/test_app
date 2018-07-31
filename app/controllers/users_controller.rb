class UsersController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :edit, :index, :update]
  before_action :authorization, only: [:edit, :update]
  before_action :admin?, only: [:destroy]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      message = "Please check you email"
      message = " to active your account"
      flash[:info] = message
      redirect_to root_url # ekvivalent ~ redirect_to user_url(@user)
    else
      render 'new'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    unless @user.activated?
    flash[:danger] = "User has ben not activated"
    redirect_to root_url 
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
    ###@users = User.paginate(page: params[:page])
  end

  def update
    @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        flash[:success] = "Successful update!"
        redirect_to @user
      else
        render 'edit'
      end
  end

  ### Before Action 

  def admin?
    redirect_to(root_url) unless current_user.admin?  
  end

  def authorization
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def logged_in_user
    unless logged_in?
      remember_location
      flash[:danger] = "Please log in"
      redirect_to login_path
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end

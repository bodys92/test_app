class UsersController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :edit, :index, :update]
  before_action :authorization, only: [:edit, :update]
  before_action :admin?, only: [:destroy]

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Successful registration!"
      redirect_to @user # ekvivalent ~ redirect_to user_url(@user)
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
  end

  def index
    @users = User.paginate(page: params[:page])
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

end

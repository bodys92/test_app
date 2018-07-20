class UsersController < ApplicationController
  
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

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end
end

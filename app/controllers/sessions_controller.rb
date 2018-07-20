class SessionsController < ApplicationController
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Successful login!"
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "Wrong email or password"
      # create error message
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def new
  end

end

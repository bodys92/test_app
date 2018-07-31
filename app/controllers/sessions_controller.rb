class SessionsController < ApplicationController
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        flash[:success] = "Successful login!"
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated"
        message += "Check you email for activation link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Wrong email or password"
      # create error message
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def new
    
  end

end

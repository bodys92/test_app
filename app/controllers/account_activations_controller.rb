class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate
            message = "Account has ben activated"
            message = ", you can now log in."
            flash[:success] = message
            redirect_to login_url
        end
    end
end

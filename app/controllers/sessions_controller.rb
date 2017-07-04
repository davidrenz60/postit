class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      if user.two_factor_auth?
        configure_two_factor_auth(user)
      else
        login_user(user)
      end
    else
      flash[:error] = "There is something wrong with your username or password."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You are logged out"
    redirect_to root_path
  end

  def pin
    access_denied if session[:two_factor].nil?

    if request.post?
      user = User.find_by(pin: params[:pin])
      if user
        session[:two_factor] = nil
        user.remove_pin!
        login_user(user)
      else
        flash[:error] = "Something is wrong with your pin."
        redirect_to pin_path
      end
    end
  end
end

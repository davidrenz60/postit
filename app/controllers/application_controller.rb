class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = "You must be logged in to do that."
      redirect_to root_path
    end
  end

  def login_user(user)
    session[:user_id] = user.id
    flash[:notice] = "Welcome #{user.username}, You are logged in."
    redirect_to root_path
  end

  def configure_two_factor_auth(user)
    user.generate_pin!
    user.send_pin_to_twilio
    session[:two_factor] = true
    redirect_to pin_path
  end

  def require_admin
    access_denied unless logged_in? && current_user.admin?
  end

  def access_denied
    flash[:error] = "You don't have permission to do that."
    redirect_to root_path
  end
end

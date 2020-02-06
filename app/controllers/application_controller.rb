class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_action :verify_duo_authentication

  def verify_duo_authentication
  	redirect_to root_path unless params[:duo_auth]
  end
end

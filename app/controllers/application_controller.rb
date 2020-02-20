class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    if session[:user]
      @current_user ||= User.find(session[:user])
    else
      @current_user = nil
    end
  end

end

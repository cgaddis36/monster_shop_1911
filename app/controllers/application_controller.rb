class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user, :current_admin, :current_merchant

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user]) if session[:user]
  end

  def current_merchant
    current_user && current_user.merchant_employee?
  end

  def current_admin
    current_user && current_user.admin?
  end

end

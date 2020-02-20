class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      login(user)
      session[:user] = user.id
      flash[:success] = "You are now logged in!"
    else
      flash[:error] = "Incorrect email/password"
      render :new
    end
  end

  def destroy
    session.clear
    flash[:success] = "You have been logged out"
    redirect_to '/'
  end

  private

    def login(user)
      if user.default?
        redirect_to '/profile'
      elsif user.merchant_employee?
        redirect_to '/merchant/dashboard'
      elsif user.admin?
        redirect_to '/admin/dashboard'
      end
      session[:user] = user.id
      flash[:success] = "Welcome, #{user.name}, you are logged in!"
    end
end

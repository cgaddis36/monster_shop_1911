class UsersController < ApplicationController

  def new
  end

  def create 
    user = User.create(user_params)
    if user.valid?
      session[:user] = user.id
      flash[:welcome] = "Welcome, #{user.name}!"
      flash[:registered] = "You have registered successfully"
      redirect_to "/profile"
    else
      session[:failed_registration] = user_params 
      flash[:error] = "#{user.errors.full_messages.to_sentence}"
      redirect_to "/register"
    end
  end

  #  def create 
  #   if user_params[:password] != params[:password_confirmation]
  #     flash[:notice] = "The password and confirmation password don't match"
  #     redirect_to "/register"
  #   else 
  #     user = User.create(user_params)
  #     if user.valid?
  #       session[:user] = user.id
  #       flash[:welcome] = "Welcome, #{user.name}!"
  #       flash[:registered] = "You have registered successfully"
  #       redirect_to "/profile"
  #     else 
  #       flash[:error] = "#{user.errors.full_messages.to_sentence}"
  #       redirect_to "/register"
  #     end
  #   end
  # end


  def show 

  end

  private 
  
  def user_params 
    params.permit(:name, :street_address, :city, :state, :zip_code, :email, :password)
  end


end
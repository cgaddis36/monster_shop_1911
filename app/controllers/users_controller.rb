class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      session[:user] = @user.id
      flash[:welcome] = "Welcome, #{@user.name}!"
      flash[:registered] = "You have registered successfully"
      redirect_to "/profile"
    else
      flash[:error] = "#{@user.errors.full_messages.to_sentence}"
      render :new
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
    params.permit(:name, :street_address, :city, :state, :zip_code, :email, :password, :password_confirmation)
  end


end

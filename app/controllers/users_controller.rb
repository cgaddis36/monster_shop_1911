class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      flash[:welcome] = "Welcome, #{@user.name}!"
      flash[:registered] = "You have registered successfully"
      session[:user] = @user.id
      redirect_to "/profile"
    else
      flash[:error] = "#{@user.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def show
    if current_user
      @user = User.find(current_user.id)
    else
      render file: '/public/404'
    end
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(update_params)
      flash[:notice] = "Your profile has been updated"
      redirect_to '/profile'
    else
      flash[:alert] = current_user.errors.full_messages.to_sentence
      redirect_to '/profile/edit'
    end
  end

  private

  def user_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :email, :password, :password_confirmation)
  end

  def update_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :email)
  end

end

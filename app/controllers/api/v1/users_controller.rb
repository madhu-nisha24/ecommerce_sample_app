class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action

  def new
    @user = User.new
  end

  def create
    Rails.logger.debug "User params: #{users_params.inspect}"
    #debugger
    if not logged_in?
      @user = User.new(users_params)
      @user.role = 'customer'
      if @user.save
            flash[:success] = "Account registered!"
            redirect_to api_v1_login_path, notice: 'Account registered!'
      else
            redirect_to new_api_v1_user_path, notice: 'Email already taken. Please register using a different email address'
      end
    else
      redirect_to api_v1_login_path, notice: 'Logout existing account before registering.'
    end

  end

  def sign_in
    @user = User.find_by(email: params[:email])
    puts "****User", @user.inspect
    if @user.valid_password?(params[:password])
      session[:user_id] = @user.id
      if @user.role == "customer"
        flash[:notice] = 'User logged in successfully'
        redirect_to api_v1_home_path, notice: 'Welcome user, Logged in successfully'
      elsif @user.role == "admin"
        flash[:notice] = 'Admin logged in successfully'
        redirect_to api_v1_home_path, notice: 'Welcome admin, Logged in successfully'
      end

    else
      redirect_to api_v1_login_path, notice: 'Invalid Login, Please enter a valid password'
      end
  end

  def logout
    session[:user_id] = nil # Clear the session to log out the user
    respond_to do |format|
      format.html { redirect_to api_v1_login_path, notice: 'Successfully logged out.' }
      format.json { head :no_content } # If you're using JSON, just return no content
    end
  end


  private

  def users_params
    params.permit(:email, :password, :role)
  end
end

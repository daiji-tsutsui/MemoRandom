class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :logout]
  before_action :correct_user, only: [:edit, :update, :destroy_confirmation, :destroy]
  before_action :logged_out_user, only: [:enter, :login, :new, :create]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find_by(id: params[:id])
  end

  # GET /users/new
  def new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User was successfully created."
      redirect_to @user
    else
      flash[:danger] = @user.error_print("Fail to signup...")
      redirect_to new_user_path
    end
  end

  def enter
  end

  def login
    name = params[:name]
    @user = User.find_by(name: name)
    if @user.nil?
      flash.now[:danger] = "No user named #{name} was found..."
      render 'enter' and return
    elsif !@user.authenticate(params[:password])
      flash.now[:danger] = "Password is incorrect."
      render 'enter' and return
    else
      log_in(@user)
      flash[:success] = "Hello, #{@user.name}."
      redirect_to top_url
    end
  end

  def logout
    log_out
    redirect_to top_url
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      flash[:success] = "User was successfully updated."
      redirect_to @user
    else
      flash[:danger] = @user.error_print("Fail to update...")
      redirect_to edit_user_path
    end
  end

  def destroy_confirmation
  end

  def destroy
    name = params[:name_confirmation]
    if name != @user.name
      flash[:info] = "The name could not be confirmed."
      redirect_to delete_user_url(@user)
    else
      if @user.destroy
        log_out
        flash[:danger] = "Your account is permanently deleted... Good-bye #{name}."
        redirect_to top_url
      else
        flash[:info] = @user.error_print("Fial to delete...")
        redirect_to delete_user_url(@user)
      end
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def logged_in_user
      @user = User.find_by(id: current_user.id) if logged_in?
      if @user.nil?
        flash[:danger] = "Need to log in."
        redirect_back_or(top_url) and return false
      end
      return true
    end

    def correct_user
      if !logged_in_user || @user.id != params[:id].to_i
        flash[:danger] = "Incorrect user's operation."
        redirect_back_or(users_url)
      end
    end

    def logged_out_user
      if logged_in?
        flash[:danger] = "Still logged in."
        redirect_back_or(top_url)
      else
        @user = User.new
      end
    end
end

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

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
    @user = User.new
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

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def logged_in_user
      logged_in?
      @user = User.find_by(id: current_user.id)
      if @user.nil?
        flash[:danger] = "You need to log in."
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
end

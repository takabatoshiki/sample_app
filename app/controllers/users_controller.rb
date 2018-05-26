class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.all
    @users = User.paginate(page: params[:page])
  end
  
  # GET /users/:id
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save  # => Validation
      # Success
      @user.send_activation_email
      flash[:info] = "Please check your mail to activate your account."
      redirect_to root_url
      # GET "users/#{@user.id}" => show 
    else
      # Failure
      render 'new'
    end
  end
  
  # GET /users/:id/edit
  # params[:id] = :id
  def edit
    @user = User.find(params[:id])
    # => app/views/users/edit.hml
  end
  
  # PATCH _users/:id
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Success
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # Failure
      # @user.errors.full_messages()
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(
        :name, :email, :password,
        :password_confirmation)
    end
    
    def correct_user
      @user = User.find(params[:id])
      # redirect_to(root_url) unless @user == current_user
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

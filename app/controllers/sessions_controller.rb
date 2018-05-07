class SessionsController < ApplicationController
  
  # GET /login
  def new
    
  end
  
  # POST /login
  def create
    user = User.find_by(email: params[:session][:email])
    # => User object or false
    if user && user.authenticate(params[:session][:password])
      # Success
      log_in user
      redirect_to user
    else
      # failure
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  # DELETE /logout
  def destroy
    log_out
    redirect_to root_url
  end
end

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)

    if user && user.authenticate(session_params[:password])
      if user.activated?
        log_in(user)
        session_params[:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_url
      else
        message = 'Your account needs to be activated before you can log in. Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email and password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end
end

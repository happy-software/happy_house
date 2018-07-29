class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    user_email = params[:password_reset][:email]

    # Only try to send an email if we find the
    # user in the database.
    if user = User.find_by(email: user_email)
      user.create_reset_digest
      user.send_password_reset_email
    end

    flash[:info] = 'Check your email for a password reset link!'
    redirect_to login_path
  end

  def edit
  end

  def update
  end

  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      redirect_to root_url unless @user && @user.authenticated?(:reset, params[:id])
    end
end

class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

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
    password              = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    if password.empty? || password_confirmation.empty?
      @user.errors.add(:password, "Can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in(@user)
      flash[:success] = 'Your password has been reset!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      redirect_to root_url unless @user && @user.authenticated?(:reset, params[:id])
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'This password reset link has expired. Try requesting another password reset email.'
        redirect_to new_password_reset_url
      end
    end
end

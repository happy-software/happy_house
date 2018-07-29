class AccountActivationsController < ApplicationController
  def edit
    user             = User.find_by(email: params[:email])
    activation_token = params[:id]

    if user && !user.activated? && user.authenticated?(:activation, activation_token)
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in(user)
      flash[:success] = 'Welcome home! Your account has been activated!'
      redirect_to(user)
    else
      flash[:danger] = 'Your account could not be activated.'
      redirect_to(root_url)
    end
  end
end

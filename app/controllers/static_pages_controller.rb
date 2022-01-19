# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    redirect_to user_properties_path(current_user) if logged_in?
  end

  def help; end

  def about; end

  def contact; end
end

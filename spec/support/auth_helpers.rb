# frozen_string_literal: true

module AuthHelpers
  # For request specs: performs a real login POST.
  # user must be activated and have password "password" (factory default).
  def log_in_as(user, password: "password", remember_me: "0")
    post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
  end
end

module FeatureAuthHelpers
  # For feature specs: logs in through the UI.
  def feature_log_in(user, password: "password")
    visit "/login"
    within("form") do
      fill_in "Email", with: user.email
      fill_in "Password", with: password
    end
    click_button "Log in"
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
  config.include FeatureAuthHelpers, type: :feature
end

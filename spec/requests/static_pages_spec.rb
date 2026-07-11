# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Static pages", type: :request do
  describe "logged out" do
    %w[/help /about /contact /].each do |path|
      it "renders #{path}" do
        get path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "logged in" do
    it "redirects the home page to the user's properties" do
      user = FactoryBot.create(:user, :activated)
      log_in_as(user)

      get "/"
      expect(response).to redirect_to(user_properties_path(user))
    end
  end
end

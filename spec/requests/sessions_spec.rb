# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }

  describe "POST /login" do
    context "with valid credentials" do
      it "logs the user in and redirects to root" do
        log_in_as(user)

        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_url)

        # A protected page is now reachable (users#show redirects to properties).
        get user_path(user)
        expect(response).to redirect_to(user_properties_path(user))
      end

      it "is case-insensitive on email" do
        post login_path, params: { session: { email: user.email.upcase, password: "password" } }
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "with a wrong password" do
      it "re-renders the login form with a danger flash" do
        log_in_as(user, password: "not-the-password")

        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(422)
        expect(flash[:danger]).to match(/invalid email and password/i)
      end
    end

    context "with an unknown email" do
      it "re-renders the login form with a danger flash" do
        post login_path, params: { session: { email: "ghost@example.com", password: "password" } }

        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(422)
        expect(flash[:danger]).to match(/invalid email and password/i)
      end
    end

    context "with an unactivated account" do
      it "refuses to log in and warns the user" do
        unactivated = FactoryBot.create(:user)
        log_in_as(unactivated)

        expect(session[:user_id]).to be_nil
        expect(flash[:warning]).to match(/needs to be activated/i)
        expect(response).to redirect_to(root_url)
      end
    end

    context "with remember_me checked" do
      it "sets remember cookies and a remember digest" do
        log_in_as(user, remember_me: "1")

        expect(user.reload.remember_digest).to_not be_nil
        expect(cookies[:remember_token]).to be_present
        expect(cookies[:user_id]).to be_present
      end
    end

    context "with remember_me unchecked" do
      it "does not remember the user" do
        log_in_as(user, remember_me: "0")

        expect(user.reload.remember_digest).to be_nil
        expect(cookies[:remember_token]).to be_blank
      end
    end
  end

  describe "DELETE /logout" do
    it "logs the user out and redirects to root" do
      log_in_as(user)
      delete logout_path

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)

      # Protected pages redirect to login again.
      get edit_user_path(user)
      expect(response).to redirect_to(login_url)
    end

    it "tolerates a logout without a logged-in user" do
      delete logout_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "friendly forwarding" do
    it "sends the user to the page they originally requested" do
      get edit_user_path(user)
      expect(response).to redirect_to(login_url)
      expect(flash[:danger]).to match(/need to be logged in/i)

      log_in_as(user)
      expect(response).to redirect_to(edit_user_path(user))
    end
  end
end

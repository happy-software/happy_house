# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Password resets", type: :request do
  before { ActionMailer::Base.deliveries.clear }

  let(:user) { FactoryBot.create(:user, :activated) }

  def reset_token_for(user)
    user.create_reset_digest
    user.reset_token
  end

  describe "GET /password_resets/new" do
    it "renders the form" do
      get new_password_reset_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /password_resets" do
    context "with a known email" do
      it "creates a reset digest and emails the user" do
        post password_resets_path, params: { password_reset: { email: user.email } }

        expect(user.reload.reset_digest).to_not be_nil
        expect(user.reload.reset_sent_at).to_not be_nil
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(flash[:info]).to match(/check your email/i)
        expect(response).to redirect_to(login_path)
      end
    end

    context "with an unknown email" do
      it "responds identically but sends nothing (no user enumeration)" do
        post password_resets_path, params: { password_reset: { email: "ghost@example.com" } }

        expect(ActionMailer::Base.deliveries).to be_empty
        expect(flash[:info]).to match(/check your email/i)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /password_resets/:id/edit" do
    it "renders the form with a valid token and email" do
      token = reset_token_for(user)
      get edit_password_reset_path(token, email: user.email)
      expect(response).to have_http_status(200)
    end

    it "redirects to root with an invalid token" do
      reset_token_for(user)
      get edit_password_reset_path("bad-token", email: user.email)
      expect(response).to redirect_to(root_url)
    end

    it "redirects to root with the wrong email" do
      token = reset_token_for(user)
      get edit_password_reset_path(token, email: "someone.else@example.com")
      expect(response).to redirect_to(root_url)
    end

    it "redirects to a new reset when the link has expired" do
      token = reset_token_for(user)
      user.update_columns(reset_sent_at: 3.hours.ago)

      get edit_password_reset_path(token, email: user.email)
      expect(flash[:danger]).to match(/expired/i)
      expect(response).to redirect_to(new_password_reset_url)
    end
  end

  describe "PATCH /password_resets/:id" do
    it "rejects a blank password" do
      token = reset_token_for(user)
      patch password_reset_path(token, email: user.email),
            params: { user: { password: "", password_confirmation: "" } }

      expect(response).to have_http_status(422) # re-renders edit
      expect(session[:user_id]).to be_nil
    end

    it "rejects a mismatched confirmation" do
      token = reset_token_for(user)
      patch password_reset_path(token, email: user.email),
            params: { user: { password: "newpassword1", password_confirmation: "different1" } }

      expect(response).to have_http_status(422) # re-renders edit
      expect(session[:user_id]).to be_nil
    end

    it "resets the password, logs the user in, and allows login with the new password" do
      token = reset_token_for(user)
      patch password_reset_path(token, email: user.email),
            params: { user: { password: "newpassword1", password_confirmation: "newpassword1" } }

      expect(flash[:success]).to match(/has been reset/i)
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(user)

      delete logout_path
      log_in_as(user, password: "newpassword1")
      expect(session[:user_id]).to eq(user.id)
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Signup and account activation", type: :request do
  before { ActionMailer::Base.deliveries.clear }

  let(:valid_params) do
    {
      user: {
        name: "New Homeowner",
        email: "new.homeowner@example.com",
        password: "supersecret",
        password_confirmation: "supersecret",
      },
    }
  end

  describe "GET /start" do
    it "renders the signup page" do
      get "/start"
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users" do
    context "with valid params" do
      it "creates an unactivated user, sends the activation email, and redirects" do
        expect { post users_path, params: valid_params }.to change(User, :count).by(1)

        user = User.find_by(email: "new.homeowner@example.com")
        expect(user.activated).to eq(false)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
        expect(flash[:info]).to match(/check your email/i)
        expect(response).to redirect_to(root_url)
      end
    end

    context "with invalid params" do
      it "does not create a user and re-renders the signup form" do
        invalid = { user: valid_params[:user].merge(password: "short", password_confirmation: "short") }
        expect { post users_path, params: invalid }.to_not change(User, :count)

        expect(response).to have_http_status(200)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET /account_activations/:id/edit" do
    context "with a valid token and email" do
      it "activates the user and logs them in" do
        user = FactoryBot.create(:user)
        get edit_account_activation_path(user.activation_token, email: user.email)

        expect(user.reload.activated).to eq(true)
        expect(session[:user_id]).to eq(user.id)
        expect(flash[:success]).to match(/activated/i)
        expect(response).to redirect_to(user)
      end
    end

    context "with an invalid token" do
      it "does not activate and redirects to root" do
        user = FactoryBot.create(:user)
        get edit_account_activation_path("wrong-token", email: user.email)

        expect(user.reload.activated).to eq(false)
        expect(session[:user_id]).to be_nil
        expect(flash[:danger]).to match(/could not be activated/i)
        expect(response).to redirect_to(root_url)
      end
    end

    context "with the wrong email" do
      it "does not activate and redirects to root" do
        user = FactoryBot.create(:user)
        get edit_account_activation_path(user.activation_token, email: "someone.else@example.com")

        expect(user.reload.activated).to eq(false)
        expect(response).to redirect_to(root_url)
      end
    end

    context "when the user is already activated" do
      it "does not log in and redirects to root" do
        user = FactoryBot.create(:user, :activated)
        get edit_account_activation_path(user.activation_token, email: user.email)

        expect(session[:user_id]).to be_nil
        expect(flash[:danger]).to match(/could not be activated/i)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end

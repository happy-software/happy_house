# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user, :activated) }
  let(:other_user) { FactoryBot.create(:user, :activated) }

  describe "#log_in / #current_user / #logged_in?" do
    it "logs a user in via the session" do
      helper.log_in(user)

      expect(session[:user_id]).to eq(user.id)
      expect(helper.current_user).to eq(user)
      expect(helper.logged_in?).to eq(true)
    end

    it "has no current user with an empty session" do
      expect(helper.current_user).to be_nil
      expect(helper.logged_in?).to eq(false)
    end
  end

  describe "#current_user?" do
    it "is true for the logged-in user and false for anyone else" do
      helper.log_in(user)

      expect(helper.current_user?(user)).to eq(true)
      expect(helper.current_user?(other_user)).to eq(false)
    end
  end

  describe "#log_out" do
    it "clears the session and the memoized user" do
      helper.log_in(user)
      expect(helper.current_user).to eq(user)

      helper.log_out

      expect(session[:user_id]).to be_nil
      expect(helper.instance_variable_get(:@current_user)).to be_nil
    end
  end

  describe "remember-me cookies" do
    it "remember(user) sets a remember digest and cookies" do
      helper.remember(user)

      expect(user.reload.remember_digest).to_not be_nil
      expect(cookies[:remember_token]).to eq(user.remember_token)
    end

    it "current_user re-authenticates from the remember cookies without a session" do
      helper.remember(user)
      session.delete(:user_id)
      helper.instance_variable_set(:@current_user, nil)

      expect(helper.current_user).to eq(user)
      expect(session[:user_id]).to eq(user.id) # cookie login re-establishes the session
    end

    it "forget(user) clears the digest and cookies" do
      helper.remember(user)
      helper.forget(user)

      expect(user.reload.remember_digest).to be_nil
      expect(cookies[:remember_token]).to be_nil
    end
  end

  describe "#store_location / #redirect_back_or" do
    it "stores the forwarding url for GET requests" do
      allow(helper).to receive(:request)
        .and_return(double("request", get?: true, original_url: "http://example.com/somewhere"))
      helper.store_location

      expect(session[:forwarding_url]).to eq("http://example.com/somewhere")
    end

    it "does not store the forwarding url for non-GET requests" do
      allow(helper).to receive(:request)
        .and_return(double("request", get?: false, original_url: "http://example.com/somewhere"))
      helper.store_location

      expect(session[:forwarding_url]).to be_nil
    end
  end
end

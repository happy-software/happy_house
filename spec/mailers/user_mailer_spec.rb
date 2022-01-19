# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Happy House - Activate Your Account")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@happyhouse.live"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include(edit_account_activation_url(user.activation_token, email: user.email))
      expect(mail.body.encoded).to include("Congratulations, #{user.name}!")
    end
  end

  describe "password_reset" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }

    before { user.reset_token = User.new_token }

    it "renders the headers" do
      expect(mail.subject).to eq("Happy House - Reset Your Password")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@happyhouse.live"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include(user.reset_token)
      expect(mail.body.encoded).to include(edit_password_reset_url(user.reset_token, email: user.email))
      expect(mail.body.encoded).to include("Reset My Password")
    end
  end
end

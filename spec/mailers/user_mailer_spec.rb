require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Happy House - Activate Your Account')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(edit_account_activation_url(user.activation_token, email: user.email))
      expect(mail.body.encoded).to include("Congratulations, #{user.name}")
    end
  end

  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset }

    it 'renders the headers' do
      expect(mail.subject).to eq('Password reset')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end

end

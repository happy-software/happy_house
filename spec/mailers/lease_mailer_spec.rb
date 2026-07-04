# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeaseMailer, type: :mailer do
  describe "expiration_reminder" do
    let(:user)     { FactoryBot.create(:user, :activated) }
    let(:property) { FactoryBot.create(:property, user: user) }
    let(:lease)    { FactoryBot.create(:lease, property: property) }
    let(:mail)     { LeaseMailer.with(lease: lease).expiration_reminder }

    it "renders the headers" do
      expect(mail.subject).to eq("Lease Expiration Reminder")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@happyhouse.live"])
    end

    it "links to the lease renewal page" do
      expect(mail.body.encoded).to include("new_renewal")
      expect(mail.body.encoded).to include(property.id.to_s)
    end
  end
end

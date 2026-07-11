# frozen_string_literal: true

require "rails_helper"
require "happy_house/leases/generator"

describe HappyHouse::Leases::Generator do
  let(:tenants) { [FactoryBot.create(:tenant), FactoryBot.create(:tenant)] }
  let(:lease_details) do
    {
      street_address: "123 Happy St.",
      city: "Orlando",
      state: "FL",
      zip_code: "32837",
      tenants: tenants,
      starting_date: "January 01, 2025 12:00 AM",
      ending_date: "January 01, 2026 12:00 AM",
      rent_amount: "1800",
      lease_creation_date: Date.current.to_s,
      landlord_name: "Hebron George",
      landlord_email: "landlord@example.com",
    }
  end

  describe "#generate!" do
    # Real WickedPdf render — this is the PDF-generation upgrade canary, do not stub.
    it "renders the FL standard residential template to a PDF" do
      pdf = described_class.new(lease_details).generate!

      expect(pdf).to be_a(String)
      expect(pdf).to start_with("%PDF")
    end

    it "raises for a state without a template" do
      generator = described_class.new(lease_details.merge(state: "CA"))
      expect { generator.generate! }.to raise_error(Errno::ENOENT)
    end
  end
end

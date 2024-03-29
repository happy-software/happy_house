# frozen_string_literal: true

require "rails_helper"

RSpec.describe "leases/index", type: :view do
  let(:user)            { create(:user) }
  let(:property)        { create(:property, user: user) }
  let(:lease_frequency) { create(:lease_frequency) }
  let(:first_lease)     { Lease.create!(property_id: property.id, lease_frequency_id: lease_frequency.id, details: "", **lease_dates) }
  let(:second_lease)    { Lease.create!(property_id: property.id, lease_frequency_id: lease_frequency.id, details: "", **lease_dates) }

  let(:fake_attachment) { fixture_file_upload(Rails.root.join("public", "apple-touch-icon.png"), "image/png") }
  let(:lease_dates) { {start_date: Date.yesterday, end_date: Date.tomorrow} }

  before do
    first_lease.contract.attach(fake_attachment)
    second_lease.contract.attach(fake_attachment)
    assign(:property, property)
    assign(:leases, [first_lease, second_lease])
    assign(:current_user, user)
  end

  it "renders a list of leases" do
    render
  end
end

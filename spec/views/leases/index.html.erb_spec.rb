require 'rails_helper'

RSpec.describe "leases/index", type: :view do
  let(:user)            { create(:user) }
  let(:property)        { create(:property, user: user) }
  let(:lease_frequency) { create(:lease_frequency) }
  let(:first_lease)     { Lease.create!(property_id: property.id, lease_frequency_id: lease_frequency.id, details: '') }
  let(:second_lease)    { Lease.create!(property_id: property.id, lease_frequency_id: lease_frequency.id, details: '') }
  
  let(:fake_attachment) { fixture_file_upload(Rails.root.join('public', 'apple-touch-icon.png'), 'image/png') }


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

require 'rails_helper'

RSpec.describe "leases/edit", type: :view do
  let(:user) { create(:user) }
  let(:property) { create(:property, user: user) }
  # let(:property) { user.properties.create!(property_type: Property::PROPERTY_TYPES.sample.to_s.titleize) }
  let(:lease_frequency) { LeaseFrequency.create(frequency: 'every_month') }
  let(:lease) { Lease.create!(property_id: property.id, lease_frequency_id: lease_frequency.id, details: '') }

  before(:each) do
    @property = assign(:property, property)
    @lease = assign(:lease, lease)
  end

  it "renders the edit lease form" do
    render

    assert_select "form[action=?][method=?]", property_lease_path(@property, @lease), "post" do

      # assert_select "input[name=?]", "lease[details]"

      assert_select "input[name=?]", "lease[contract]"
    end
  end
end

require 'rails_helper'

RSpec.describe "leases/edit", type: :view do
  let(:user)            { create(:user) }
  let(:property)        { create(:property, user: user) }
  let(:lease_frequency) { LeaseFrequency.create(frequency: 'every_month') }
  let(:lease)           { Lease.create!(property_id: property.id, lease_frequency_id: lease_frequency.id, details: '') }

  before do
    assign(:property, property)
    assign(:lease, lease)
    assign(:current_user, user)
  end

  it "renders the edit lease form" do
    render

    assert_select "form[action=?][method=?]", user_property_lease_path(user, property, lease), "post" do
      assert_select "input[name=?]", "lease[contract]"
    end
  end
end

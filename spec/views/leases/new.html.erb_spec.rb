require 'rails_helper'

RSpec.describe "leases/new", type: :view do
  let(:user) { create(:user) }
  let(:property) { create(:property, user: user) }
  let(:lease_frequency) { create(:lease_frequency) }
  let(:lease) { Lease.create!(property_id: property.id, lease_frequency_id: lease_frequency.id, details: '') }

  before do
    assign(:property, property)
    assign(:lease, lease)
  end

  it "renders new lease form" do
    render

    assert_select "form[action=?][method=?]", property_lease_path(property, lease), "post" do
      assert_select "input[name=?]", "lease[contract]"
    end
  end
end

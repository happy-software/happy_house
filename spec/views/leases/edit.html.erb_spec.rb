require 'rails_helper'

RSpec.describe "leases/edit", type: :view do
  before(:each) do
    @lease = assign(:lease, Lease.create!(
      :details => "",
      :property_document_id => 1
    ))
  end

  it "renders the edit lease form" do
    render

    assert_select "form[action=?][method=?]", lease_path(@lease), "post" do

      assert_select "input[name=?]", "lease[details]"

      assert_select "input[name=?]", "lease[property_document_id]"
    end
  end
end

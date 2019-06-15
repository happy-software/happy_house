require 'rails_helper'

RSpec.describe "leases/index", type: :view do
  before(:each) do
    assign(:leases, [
      Lease.create!(
        :details => "",
        :property_document_id => 2
      ),
      Lease.create!(
        :details => "",
        :property_document_id => 2
      )
    ])
  end

  it "renders a list of leases" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end

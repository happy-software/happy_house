require 'rails_helper'

RSpec.describe "leases/new", type: :view do
  before(:each) do
    assign(:lease, Lease.new(
      :details => "",
      :property_document_id => 1
    ))
  end

  it "renders new lease form" do
    render

    assert_select "form[action=?][method=?]", leases_path, "post" do

      # assert_select "input[name=?]", "lease[details]"

      assert_select "input[name=?]", "lease[property_document_id]"
    end
  end
end

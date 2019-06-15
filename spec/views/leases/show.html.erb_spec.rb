require 'rails_helper'

RSpec.describe "leases/show", type: :view do
  before(:each) do
    @lease = assign(:lease, Lease.create!(
      :details => "",
      :property_document_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end

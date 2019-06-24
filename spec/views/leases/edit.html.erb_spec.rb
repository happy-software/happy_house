require 'rails_helper'

RSpec.describe "leases/edit", type: :view do
  before(:each) do
    @property = Property.create
    @property_document = PropertyDocument.create(property: @property, property_document_type: PropertyDocumentType.create)
    @lease_frequency   = LeaseFrequency.create(frequency: 'every_second')
    @lease = assign(:lease, Lease.create!(
      :details => "",
      :property_document_id => @property_document&.id,
      :lease_frequency_id   => @lease_frequency&.id,
    ))
  end

  it "renders the edit lease form" do
    render

    assert_select "form[action=?][method=?]", lease_path(@lease), "post" do

      # assert_select "input[name=?]", "lease[details]"

      assert_select "input[name=?]", "lease[property_document_id]"
    end
  end
end

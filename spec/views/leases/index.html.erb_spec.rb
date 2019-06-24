require 'rails_helper'

RSpec.describe "leases/index", type: :view do
  before(:each) do
    @property = Property.create
    @property_document = PropertyDocument.create(property: @property, property_document_type: PropertyDocumentType.create)
    @lease_frequency   = LeaseFrequency.create(frequency: 'every_second')
    assign(:leases, [
      Lease.create!(
        :details => "",
        :property_document_id => @property_document&.id,
        :lease_frequency_id   => @lease_frequency&.id,
      ),
      Lease.create!(
        :details => "",
        :property_document_id => @property_document&.id,
        :lease_frequency_id   => @lease_frequency&.id,
      )
    ])
  end

  it "renders a list of leases" do
    render
  end
end

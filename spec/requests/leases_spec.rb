require 'rails_helper'

RSpec.describe "Leases", type: :request do
  let(:mock_property) { Property.new(id: 1) }

  before do
    allow(Property).to receive(:find).and_return(mock_property)
  end

  describe "GET /leases" do
    it "works! (now write some real specs)" do
      get property_leases_path(property_id: mock_property.id)
      expect(response).to have_http_status(200)
    end
  end
end

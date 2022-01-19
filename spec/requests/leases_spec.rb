# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Leases", type: :request do
  let(:mock_user)     { User.new(id: 1, password: "password", email: "test@test.com", activated: true) }
  let(:mock_property) { Property.new(id: 1, user: mock_user) }

  before do
    allow(User).to receive(:find_by).and_return(mock_user)
    allow(Property).to receive(:find).and_return(mock_property)
  end

  describe "GET /leases" do
    it "works!" do
      post login_path, params: { session: { email: mock_user.email, password: mock_user.password } }
      get user_property_leases_path(user_id: mock_user.id, property_id: mock_property.id)
      expect(response).to have_http_status(200)
    end
  end
end

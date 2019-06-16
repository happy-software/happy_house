require 'rails_helper'

RSpec.describe "Leases", type: :request do
  describe "GET /leases" do
    it "works! (now write some real specs)" do
      get leases_path
      expect(response).to have_http_status(200)
    end
  end
end

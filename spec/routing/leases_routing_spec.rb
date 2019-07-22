require "rails_helper"

RSpec.describe LeasesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/properties/1/leases").to route_to("leases#index", property_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/properties/1/leases/new").to route_to("leases#new", property_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/properties/1/leases/1").to route_to("leases#show", property_id: '1', id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/properties/1/leases/1/edit").to route_to("leases#edit", property_id: '1', id: '1')
    end


    it "routes to #create" do
      expect(:post => "/properties/1/leases").to route_to("leases#create", property_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/properties/1/leases/1").to route_to("leases#update", property_id: '1', id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/properties/1/leases/1").to route_to("leases#update", property_id: '1', id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/properties/1/leases/1").to route_to("leases#destroy", property_id: '1', id: '1')
    end
  end
end

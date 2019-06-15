require "rails_helper"

RSpec.describe LeasesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/leases").to route_to("leases#index")
    end

    it "routes to #new" do
      expect(:get => "/leases/new").to route_to("leases#new")
    end

    it "routes to #show" do
      expect(:get => "/leases/1").to route_to("leases#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/leases/1/edit").to route_to("leases#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/leases").to route_to("leases#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/leases/1").to route_to("leases#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/leases/1").to route_to("leases#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/leases/1").to route_to("leases#destroy", :id => "1")
    end
  end
end

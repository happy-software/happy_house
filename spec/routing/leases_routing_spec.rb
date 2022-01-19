# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeasesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/users/1/properties/1/leases").to route_to("leases#index", user_id: "1", property_id: "1")
    end

    it "routes to #new" do
      expect(get: "/users/1/properties/1/leases/new").to route_to("leases#new", user_id: "1", property_id: "1")
    end

    it "routes to #show" do
      expect(get: "/users/1/properties/1/leases/1").to route_to("leases#show", user_id: "1", property_id: "1",
                                                                               id: "1")
    end

    it "routes to #edit" do
      expect(get: "/users/1/properties/1/leases/1/edit").to route_to("leases#edit", user_id: "1", property_id: "1",
                                                                                    id: "1")
    end

    it "routes to #create" do
      expect(post: "/users/1/properties/1/leases").to route_to("leases#create", user_id: "1", property_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/users/1/properties/1/leases/1").to route_to("leases#update", user_id: "1", property_id: "1",
                                                                                 id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/users/1/properties/1/leases/1").to route_to("leases#update", user_id: "1", property_id: "1",
                                                                                   id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/users/1/properties/1/leases/1").to route_to("leases#destroy", user_id: "1", property_id: "1",
                                                                                     id: "1")
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Properties", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }

  before { log_in_as(user) }

  describe "GET /users/:user_id/properties" do
    it "lists the user's properties" do
      property
      get user_properties_path(user)

      expect(response).to have_http_status(200)
      expect(response.body).to include(property.display_name)
    end
  end

  describe "GET /users/:user_id/properties/new" do
    it "renders the form" do
      get new_user_property_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users/:user_id/properties" do
    let(:valid_params) do
      {
        property: {
          nickname: "Casa Nueva",
          property_type: "Condo",
          address: {
            street_address: "42 Wallaby Way",
            city: "Sydney",
            state: "FL",
            zip_code: "32837",
          },
        },
      }
    end

    it "creates a property with valid params" do
      expect { post user_properties_path(user), params: valid_params }
        .to change(user.properties, :count).by(1)

      expect(flash[:success]).to match(/new happy home/i)
      expect(response).to redirect_to(root_url)

      created = user.properties.last
      expect(created.address["street_address"]).to eq("42 Wallaby Way")
    end

    it "re-renders the form with invalid params" do
      invalid = { property: valid_params[:property].merge(property_type: nil) }
      expect { post user_properties_path(user), params: invalid }
        .to_not change(Property, :count)

      expect(response).to have_http_status(422)
    end
  end

  describe "GET /users/:user_id/properties/:id" do
    it "shows the property (zpid is nil, so no price-history API call)" do
      get user_property_path(user, property)
      expect(response).to have_http_status(200)
      expect(response.body).to include(property.display_name)
    end
  end

  describe "GET /users/:user_id/properties/:id/edit" do
    it "renders the edit form" do
      get edit_user_property_path(user, property)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /users/:user_id/properties/:id" do
    it "updates the property with valid params" do
      patch user_property_path(user, property), params: { property: { nickname: "Renamed" } }

      expect(property.reload.nickname).to eq("Renamed")
      expect(flash[:success]).to match(/updated/i)
      expect(response).to redirect_to(user)
    end

    it "re-renders edit with invalid params" do
      patch user_property_path(user, property), params: { property: { property_type: "Castle" } }

      expect(property.reload.property_type).to_not eq("Castle")
      expect(response).to have_http_status(422)
    end
  end

  describe "PATCH upload_files" do
    # Dead feature: no view links to it, `correct_user` reads params[:id]
    # (the nested route only provides :property_id), and Property no longer
    # has a `documents` attachment. See TEST_COVERAGE_PLAN.md BUG-6.
    it "raises RecordNotFound because the route param never matches" do
      expect do
        patch user_property_upload_property_documents_path(user, property),
              params: { property: { documents: [uploaded_test_file] } }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

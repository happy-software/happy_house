# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Insurance documents", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }

  before { log_in_as(user) }

  describe "GET index" do
    it "lists documents newest-first" do
      older = FactoryBot.create(:insurance_document, property: property, title: "Policy 2023")
      newer = FactoryBot.create(:insurance_document, property: property, title: "Policy 2024")
      older.update_columns(created_at: 1.year.ago)

      get user_property_insurance_documents_path(user, property)

      expect(response).to have_http_status(200)
      expect(response.body.index("Policy 2024")).to be < response.body.index("Policy 2023")
    end
  end

  describe "GET new" do
    it "renders the form" do
      get new_user_property_insurance_document_path(user, property)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    it "uploads a document with valid params" do
      expect do
        post user_property_insurance_documents_path(user, property),
             params: { insurance_document: { title: "Policy", document: uploaded_test_file } }
      end.to change(property.insurance_documents, :count).by(1)

      expect(response).to redirect_to(user_property_insurance_documents_path([user, property]))
    end

    it "re-renders the form without a document" do
      expect do
        post user_property_insurance_documents_path(user, property),
             params: { insurance_document: { title: "No File" } }
      end.to_not change(InsuranceDocument, :count)

      expect(response).to have_http_status(422)
    end
  end

  describe "unauthenticated access" do
    it "redirects to root" do
      delete logout_path
      get user_property_insurance_documents_path(user, property)
      expect(response).to redirect_to(root_url)
    end
  end
end

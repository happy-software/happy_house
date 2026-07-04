# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Purchase documents", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }
  let(:document) { FactoryBot.create(:purchase_document, property: property, title: "Closing Docs") }

  before { log_in_as(user) }

  describe "GET index" do
    it "lists documents newest-first" do
      older = FactoryBot.create(:purchase_document, property: property, title: "Old Contract")
      newer = FactoryBot.create(:purchase_document, property: property, title: "New Contract")
      older.update_columns(created_at: 1.year.ago)

      get user_property_purchase_documents_path(user, property)

      expect(response).to have_http_status(200)
      expect(response.body.index("New Contract")).to be < response.body.index("Old Contract")
    end
  end

  describe "GET new" do
    it "renders the form" do
      get new_user_property_purchase_document_path(user, property)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    it "uploads a document with valid params" do
      expect do
        post user_property_purchase_documents_path(user, property),
             params: { purchase_document: { title: "Deed", document: uploaded_test_file } }
      end.to change(property.purchase_documents, :count).by(1)

      expect(response).to redirect_to(user_property_purchase_documents_path([user, property]))
    end

    it "re-renders the form without a document" do
      expect do
        post user_property_purchase_documents_path(user, property),
             params: { purchase_document: { title: "No File" } }
      end.to_not change(PurchaseDocument, :count)

      expect(response).to have_http_status(200)
    end
  end

  describe "GET show" do
    it "renders the document page" do
      get user_property_purchase_document_path(user, property, document)
      expect(response).to have_http_status(200)
      expect(response.body).to include("Closing Docs")
    end
  end

  describe "GET edit / PATCH update" do
    it "renders the edit form" do
      get edit_user_property_purchase_document_path(user, property, document)
      expect(response).to have_http_status(200)
    end

    it "updates the title" do
      patch user_property_purchase_document_path(user, property, document),
            params: { purchase_document: { title: "Renamed Docs" } }

      expect(document.reload.title).to eq("Renamed Docs")
      expect(response).to redirect_to([user, property, document])
    end

    it "re-renders edit with a blank title" do
      patch user_property_purchase_document_path(user, property, document),
            params: { purchase_document: { title: "" } }

      expect(document.reload.title).to eq("Closing Docs")
      expect(response).to have_http_status(200)
    end
  end
end

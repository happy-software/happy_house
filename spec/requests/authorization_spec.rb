# frozen_string_literal: true

require "rails_helper"

# Every controller nested under a property has a `correct_user` guard that must
# send anyone who is not the property's owner back to root.
RSpec.describe "Authorization (correct_user guards)", type: :request do
  let(:owner)      { FactoryBot.create(:user, :activated) }
  let(:other_user) { FactoryBot.create(:user, :activated) }
  let(:property)   { FactoryBot.create(:property, user: owner) }

  let(:lease)              { FactoryBot.create(:lease, property: property) }
  let(:expense_item)       { FactoryBot.create(:expense_item, property: property) }
  let(:event)              { FactoryBot.create(:event, property: property) }
  let(:insurance_document) { FactoryBot.create(:insurance_document, property: property) }
  let(:purchase_document)  { FactoryBot.create(:purchase_document, property: property) }
  let(:mortgage_statement) { FactoryBot.create(:mortgage_statement, property: property) }

  describe "properties#show" do
    subject { get user_property_path(owner, property) }
    include_examples "redirects other users to root"
  end

  describe "properties#edit" do
    subject { get edit_user_property_path(owner, property) }
    include_examples "redirects other users to root"
  end

  describe "expense_items#index" do
    subject { get user_property_expense_items_path(owner, property) }
    include_examples "redirects other users to root"
  end

  describe "expense_items#show" do
    subject { get user_property_expense_item_path(owner, property, expense_item) }
    include_examples "redirects other users to root"
  end

  describe "leases#index" do
    subject { get user_property_leases_path(owner, property) }
    include_examples "redirects other users to root"
  end

  describe "leases#show" do
    subject { get user_property_lease_path(owner, property, lease) }
    include_examples "redirects other users to root"
  end

  describe "events#index" do
    subject { get user_property_events_path(owner, property) }
    include_examples "redirects other users to root"
  end

  describe "events#show" do
    subject { get user_property_event_path(owner, property, event) }
    include_examples "redirects other users to root"
  end

  describe "insurance_documents#index" do
    subject { get user_property_insurance_documents_path(owner, property) }
    include_examples "redirects other users to root"
  end

  describe "purchase_documents#show" do
    subject { get user_property_purchase_document_path(owner, property, purchase_document) }
    include_examples "redirects other users to root"
  end

  describe "mortgage_statements#show" do
    subject { get user_property_mortgage_statement_path(owner, property, mortgage_statement) }
    include_examples "redirects other users to root"
  end

  # These two controllers read params[:id] (not the nested :property_id), so the
  # property id must be passed as an explicit query param — without it the pages
  # 404 for everyone. See TEST_COVERAGE_PLAN.md BUG-2.
  describe "mortgage_expenses#index" do
    subject { get user_property_new_mortgage_expense_path(owner, property, id: property.id) }
    include_examples "redirects other users to root"
  end

  describe "hoa_expenses#index" do
    subject { get user_property_new_hoa_expense_path(owner, property, id: property.id) }
    include_examples "redirects other users to root"
  end

  describe "users#edit (correct_user on UsersController)" do
    it "redirects a different user to their own page, not root" do
      log_in_as(other_user)
      get edit_user_path(owner)
      expect(response).to redirect_to(other_user)
    end
  end

  describe "unauthenticated access" do
    it "redirects logged-out visitors to root for leases" do
      get user_property_leases_path(owner, property)
      expect(response).to redirect_to(root_url)
    end

    it "redirects logged-out visitors to root for insurance documents" do
      get user_property_insurance_documents_path(owner, property)
      expect(response).to redirect_to(root_url)
    end
  end
end

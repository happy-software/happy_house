# frozen_string_literal: true

require "rails_helper"

# Both controllers read params[:id] instead of the nested :property_id, and
# their #create redirects to `property_path`, a helper that does not exist.
# See TEST_COVERAGE_PLAN.md BUG-2 — these specs pin the current behavior.
RSpec.describe "Mortgage and HOA expenses", type: :request do
  let(:owner)      { FactoryBot.create(:user, :activated) }
  let(:other_user) { FactoryBot.create(:user, :activated) }
  let(:property)   { FactoryBot.create(:property, user: owner) }

  before { log_in_as(owner) }

  describe "mortgage_expenses" do
    describe "GET index" do
      it "renders with an explicit id param" do
        get user_property_new_mortgage_expense_path(owner, property, id: property.id)
        expect(response).to have_http_status(200)
      end

      it "404s without the id param (BUG-2: params[:id] is not in the route)" do
        expect do
          get user_property_new_mortgage_expense_path(owner, property)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "POST create" do
      it "creates 12 expense items, then raises on the broken property_path redirect (BUG-2)" do
        expect do
          expect do
            post user_property_create_yearly_mortgage_expense_path(owner, property),
                 params: { id: property.id, year: "2024", monthly_payment: "1200.50" }
          end.to raise_error(NameError, /property_path/)
        end.to change(property.expense_items, :count).by(12)

        expect(property.expense_items.pluck(:name)).to include("1-2024 Mortgage Payment",
                                                               "12-2024 Mortgage Payment")
      end
    end
  end

  describe "hoa_expenses" do
    describe "GET index" do
      it "renders with an explicit id param" do
        get user_property_new_hoa_expense_path(owner, property, id: property.id)
        expect(response).to have_http_status(200)
      end
    end

    describe "POST create" do
      it "creates 12 expense items, then raises on the broken property_path redirect (BUG-2)" do
        expect do
          expect do
            post user_property_create_yearly_hoa_expense_path(owner, property),
                 params: { id: property.id, year: "2024", monthly_payment: "150.0" }
          end.to raise_error(NameError, /property_path/)
        end.to change(property.expense_items, :count).by(12)

        expect(property.expense_items.pluck(:name)).to include("1-2024 HOA Payment",
                                                               "12-2024 HOA Payment")
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Expense items", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }

  before { log_in_as(user) }

  describe "GET index" do
    it "renders the yearly expense summary" do
      FactoryBot.create(:expense_item, property: property, name: "Roof", expense_date: Date.new(2023, 3, 1))
      FactoryBot.create(:expense_item, property: property, name: "Fence", expense_date: Date.new(2024, 4, 1))

      get user_property_expense_items_path(user, property)

      expect(response).to have_http_status(200)
      expect(response.body).to include("2023")
      expect(response.body).to include("2024")
    end
  end

  describe "GET new" do
    it "renders the form" do
      get new_user_property_expense_item_path(user, property)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    let(:valid_params) do
      { expense_item: { name: "New Water Heater", cost: 850.0, expense_date: "2024-02-01" } }
    end

    it "creates an expense item with valid params" do
      expect { post user_property_expense_items_path(user, property), params: valid_params }
        .to change(property.expense_items, :count).by(1)

      expect(flash[:info]).to match(/saved/i)
      expect(response).to redirect_to(user_property_expense_items_url(user, property))
    end

    it "re-renders the form with invalid params" do
      invalid = { expense_item: { name: "", cost: 1.0, expense_date: "2024-02-01" } }
      expect { post user_property_expense_items_path(user, property), params: invalid }
        .to_not change(ExpenseItem, :count)

      expect(response).to have_http_status(422)
    end
  end

  describe "GET show" do
    # There is no expense_items/show template — the action is dead code (the
    # UI links to edit instead). See TEST_COVERAGE_PLAN.md BUG-7.
    it "raises because the show template does not exist (BUG-7)" do
      item = FactoryBot.create(:expense_item, property: property, name: "Paint Job")

      expect { get user_property_expense_item_path(user, property, item) }
        .to raise_error(ActionController::MissingExactTemplate)
    end
  end

  describe "GET edit / PATCH update" do
    let(:item) { FactoryBot.create(:expense_item, property: property, name: "Old Name") }

    it "renders the edit form" do
      get edit_user_property_expense_item_path(user, property, item)
      expect(response).to have_http_status(200)
    end

    it "updates with valid params" do
      patch user_property_expense_item_path(user, property, item),
            params: { expense_item: { name: "New Name" } }

      expect(item.reload.name).to eq("New Name")
      expect(flash[:success]).to match(/updated expense item/i)
      expect(response).to redirect_to(user_property_expense_items_url(property_id: property.id))
    end

    it "re-renders edit with invalid params" do
      patch user_property_expense_item_path(user, property, item),
            params: { expense_item: { name: "" } }

      expect(item.reload.name).to eq("Old Name")
      expect(response).to have_http_status(422)
    end
  end

  describe "GET report" do
    # Renders the groupdate-powered monthly summary + expense table — a key
    # upgrade canary for the groupdate and chartkick gems.
    it "renders the yearly report with expense names and total" do
      FactoryBot.create(:expense_item, property: property, name: "Gutter Cleaning",
                                       cost: 100.0, expense_date: Date.new(2024, 3, 10))
      FactoryBot.create(:expense_item, property: property, name: "Lawn Care",
                                       cost: 50.0, expense_date: Date.new(2024, 7, 5))

      get report_user_property_expense_items_path(user, property, expense_year: "2024")

      expect(response).to have_http_status(200)
      expect(response.body).to include("Gutter Cleaning")
      expect(response.body).to include("Lawn Care")
      expect(response.body).to include("$150.00")
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Mortgage statements", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }
  let(:statement) { FactoryBot.create(:mortgage_statement, property: property, title: "March Statement") }

  before { log_in_as(user) }

  describe "GET index" do
    it "lists statements newest-first" do
      older = FactoryBot.create(:mortgage_statement, property: property, title: "January Statement")
      newer = FactoryBot.create(:mortgage_statement, property: property, title: "February Statement")
      older.update_columns(created_at: 1.year.ago)

      get user_property_mortgage_statements_path(user, property)

      expect(response).to have_http_status(200)
      expect(response.body.index("February Statement")).to be < response.body.index("January Statement")
    end
  end

  describe "GET new" do
    it "renders the form" do
      get new_user_property_mortgage_statement_path(user, property)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    it "uploads a statement with valid params, including rich-text notes" do
      expect do
        post user_property_mortgage_statements_path(user, property),
             params: { mortgage_statement: { title: "April Statement",
                                             document: uploaded_test_file,
                                             notes: "Paid extra principal" } }
      end.to change(property.mortgage_statements, :count).by(1)

      created = property.mortgage_statements.order(:created_at).last
      expect(created.notes.to_plain_text).to include("Paid extra principal")
      expect(response).to redirect_to(user_property_mortgage_statements_path([user, property]))
    end

    it "re-renders the form without a document" do
      expect do
        post user_property_mortgage_statements_path(user, property),
             params: { mortgage_statement: { title: "No File" } }
      end.to_not change(MortgageStatement, :count)

      expect(response).to have_http_status(200)
    end
  end

  # The show and edit templates were never created for mortgage statements —
  # the controller actions exist but 500 with a missing-template error.
  # See TEST_COVERAGE_PLAN.md BUG-8.
  describe "GET show" do
    it "raises because the show template does not exist (BUG-8)" do
      expect { get user_property_mortgage_statement_path(user, property, statement) }
        .to raise_error(ActionController::MissingExactTemplate)
    end
  end

  describe "GET edit / PATCH update" do
    it "raises because the edit template does not exist (BUG-8)" do
      expect { get edit_user_property_mortgage_statement_path(user, property, statement) }
        .to raise_error(ActionController::MissingExactTemplate)
    end

    it "updates the title" do
      patch user_property_mortgage_statement_path(user, property, statement),
            params: { mortgage_statement: { title: "Renamed Statement" } }

      expect(statement.reload.title).to eq("Renamed Statement")
      expect(response).to redirect_to([user, property, statement])
    end

    it "raises on a blank title because the edit re-render has no template (BUG-8)" do
      expect do
        patch user_property_mortgage_statement_path(user, property, statement),
              params: { mortgage_statement: { title: "" } }
      end.to raise_error(ActionView::MissingTemplate)

      expect(statement.reload.title).to eq("March Statement")
    end
  end
end

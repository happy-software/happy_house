# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Events", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }
  let(:event) do
    FactoryBot.create(:event, property: property, title: "Roof Inspection",
                              starts_at: 2.months.ago, ends_at: 2.months.ago)
  end

  before { log_in_as(user) }

  describe "GET index (simple_calendar upgrade canary)" do
    it "renders the calendar including expense items as pseudo-events" do
      # Expense items are merged into the calendar as OpenStructs; one dated in
      # the displayed (current) month must appear on the calendar.
      FactoryBot.create(:expense_item, property: property, name: "HVAC Service",
                                       expense_date: Date.current)

      get user_property_events_path(user, property)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Event Calendar")
      expect(response.body).to include("HVAC Service")
    end

    it "renders fine when events exist outside the displayed month" do
      event # 2 months ago — not on the current month's calendar
      get user_property_events_path(user, property)

      expect(response).to have_http_status(200)
    end

    it "shows real Events in the displayed month linked via EventsHelper#event_path" do
      this_month = FactoryBot.create(:event, property: property, title: "This Month",
                                             starts_at: Time.current, ends_at: Time.current)

      get user_property_events_path(user, property)

      expect(response).to have_http_status(200)
      expect(response.body)
        .to include(user_property_event_path(user, property, this_month))
    end
  end

  describe "GET show / new / edit" do
    it "renders the event page" do
      get user_property_event_path(user, property, event)
      expect(response).to have_http_status(200)
      expect(response.body).to include("Roof Inspection")
    end

    it "renders the new form" do
      get new_user_property_event_path(user, property)
      expect(response).to have_http_status(200)
    end

    it "renders the edit form" do
      get edit_user_property_event_path(user, property, event)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    # Only the HTML path is tested: the JSON success branch references an
    # undefined local variable. See TEST_COVERAGE_PLAN.md BUG-1.
    it "creates an event with rich-text content" do
      expect do
        post user_property_events_path(user, property),
             params: { event: { title: "Gutter Cleaning", starts_at: "2024-05-01T10:00",
                                ends_at: "2024-05-01T11:00", content: "Bring a ladder" } }
      end.to change(property.events, :count).by(1)

      created = property.events.order(:created_at).last
      expect(created.content.to_plain_text).to include("Bring a ladder")
      expect(response).to redirect_to(user_property_event_url(user, property, created))
    end
  end

  describe "PATCH update" do
    it "updates the event" do
      patch user_property_event_path(user, property, event),
            params: { event: { title: "Updated Title" } }

      expect(event.reload.title).to eq("Updated Title")
      expect(response).to redirect_to(user_property_event_url(user, property, event))
    end
  end

  describe "DELETE destroy" do
    it "removes the event" do
      event
      expect { delete user_property_event_path(user, property, event) }
        .to change(Event, :count).by(-1)

      expect(response).to redirect_to(user_property_events_url(user, property))
    end
  end
end

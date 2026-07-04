# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Leases CRUD", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }
  let!(:lease_frequency) { LeaseFrequency.find_or_create_by!(id: 1) { |lf| lf.frequency = "monthly" } }
  let(:lease) { FactoryBot.create(:lease, property: property, lease_frequency: lease_frequency) }

  before { log_in_as(user) }

  describe "GET index" do
    it "lists leases newest-first" do
      older = FactoryBot.create(:lease, property: property, start_date: 2.years.ago, end_date: 1.year.ago)
      newer = FactoryBot.create(:lease, property: property, start_date: 1.month.ago, end_date: 11.months.from_now)

      get user_property_leases_path(user, property)

      expect(response).to have_http_status(200)
      expect(response.body.index(newer.start_date.year.to_s))
        .to be < response.body.index(older.start_date.year.to_s)
    end
  end

  describe "GET new / GET edit" do
    it "renders the new form" do
      get new_user_property_lease_path(user, property)
      expect(response).to have_http_status(200)
    end

    it "renders the edit form" do
      get edit_user_property_lease_path(user, property, lease)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    let(:valid_params) do
      {
        lease: {
          start_date: "2024-01-01T00:00",
          end_date: "2025-01-01T00:00",
          amount: 1750.0,
          lease_frequency_id: lease_frequency.id,
        },
      }
    end

    it "creates a lease with valid params" do
      expect { post user_property_leases_path(user, property), params: valid_params }
        .to change(property.leases, :count).by(1)

      created = property.leases.order(:created_at).last
      expect(response).to redirect_to(user_property_lease_url(user, property, created))
    end

    it "re-renders new with invalid params" do
      invalid = { lease: valid_params[:lease].merge(lease_frequency_id: nil) }
      expect { post user_property_leases_path(user, property), params: invalid }
        .to_not change(Lease, :count)

      expect(response).to have_http_status(200)
    end
  end

  describe "GET show" do
    it "renders the lease page" do
      get user_property_lease_path(user, property, lease)
      expect(response).to have_http_status(200)
    end

    # The PDF download is currently broken: the controller asks wicked_pdf for
    # template "leases/show.html.erb" but only show.slim exists, so template
    # lookup fails. See TEST_COVERAGE_PLAN.md BUG-9 — the planned PDF-renderer
    # replacement should FIX this rather than preserve it. (Real PDF generation
    # is still covered by spec/happy_house/leases/generator_spec.rb.)
    it "raises MissingTemplate for the .pdf format (BUG-9)" do
      expect { get user_property_lease_path(user, property, lease, format: :pdf) }
        .to raise_error(ActionView::MissingTemplate)
    end
  end

  describe "PATCH update" do
    it "updates the lease with valid params" do
      patch user_property_lease_path(user, property, lease), params: { lease: { amount: 1999.0 } }

      expect(lease.reload.amount).to eq(1999.0)
      expect(response).to redirect_to(user_property_lease_url(user, property, lease))
    end

    it "re-renders edit with invalid params" do
      patch user_property_lease_path(user, property, lease),
            params: { lease: { lease_frequency_id: nil } }

      expect(lease.reload.lease_frequency_id).to eq(lease_frequency.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE destroy" do
    it "removes the lease" do
      lease
      expect { delete user_property_lease_path(user, property, lease) }
        .to change(Lease, :count).by(-1)

      expect(response).to redirect_to(user_property_leases_url(user, property))
    end
  end

  describe "PATCH upload_signed_lease" do
    it "attaches the signed contract" do
      patch upload_signed_lease_user_property_lease_path(user, property, lease),
            params: { lease: { signed_contract: uploaded_test_file } }

      expect(lease.reload.signed_contract).to be_attached
      expect(flash[:success]).to match(/attached signed lease/i)
      expect(response).to redirect_to(user_property_lease_url(user, property, lease))
    end
  end

  describe "GET new_renewal" do
    it "renders the renewal form with defaults derived from the old lease" do
      get user_property_lease_new_renewal_path(user, property, lease, lease_id: lease.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include(lease.end_date.strftime("%Y-%m-%d"))
    end
  end

  describe "POST create_renewal" do
    let(:tenant) { FactoryBot.create(:tenant) }
    let(:renewal_params) do
      {
        lease: {
          start_date: "2025-01-01T00:00",
          end_date: "2026-01-01T00:00",
          amount: "1800",
        },
      }
    end

    before do
      FactoryBot.create(:lease_tenant, lease: lease, tenant: tenant)
      allow_any_instance_of(HappyHouse::Leases::Generator)
        .to receive(:generate!).and_return("%PDF-1.4 fake")
    end

    it "renews the lease and redirects to the new lease" do
      expect do
        post user_property_lease_create_renewal_path(user, property, lease, lease_id: lease.id),
             params: renewal_params
      end.to change(Lease, :count).by(1)

      new_lease = Lease.order(:created_at).last
      expect(new_lease.tenants).to eq([tenant])
      expect(response).to redirect_to(user_property_lease_url(user, property, new_lease))
    end

    # See TEST_COVERAGE_PLAN.md BUG-3: the failure branch raises instead of
    # re-rendering the form.
    it "raises when the renewal fails" do
      allow_any_instance_of(HappyHouse::Leases::Generator)
        .to receive(:generate!).and_raise(StandardError, "boom")

      expect do
        post user_property_lease_create_renewal_path(user, property, lease, lease_id: lease.id),
             params: renewal_params
      end.to raise_error(StandardError, /Could not renew lease/)
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Leases::Renewer do
  let(:user)     { FactoryBot.create(:user, :activated) }
  let(:property) { FactoryBot.create(:property, user: user) }
  let(:tenant)   { FactoryBot.create(:tenant) }
  let(:original_lease) { FactoryBot.create(:lease, property: property) }

  let(:params) do
    {
      property: property,
      original_lease: original_lease,
      lease: {
        start_date: "2025-01-01",
        end_date: "2026-01-01",
        amount: "1800",
      },
    }
  end

  before do
    LeaseFrequency.find_or_create_by!(id: 1) { |lf| lf.frequency = "monthly" }
    FactoryBot.create(:lease_tenant, lease: original_lease, tenant: tenant)
  end

  describe "#call" do
    context "when the PDF generates successfully" do
      before do
        allow_any_instance_of(HappyHouse::Leases::Generator)
          .to receive(:generate!).and_return("%PDF-1.4 fake")
      end

      it "creates a new lease carrying over the tenants" do
        result = nil
        expect { result = described_class.new(params).call }.to change(Lease, :count).by(1)

        expect(result.success?).to eq(true)
        new_lease = result.payload
        expect(new_lease).to be_persisted
        expect(new_lease.tenants).to eq([tenant])
        expect(new_lease.amount).to eq(1800)
        expect(new_lease.start_date.to_date).to eq(Date.new(2025, 1, 1))
        expect(new_lease.end_date.to_date).to eq(Date.new(2026, 1, 1))
        expect(new_lease.contract).to be_attached
      end
    end

    context "when anything raises" do
      # See TEST_COVERAGE_PLAN.md BUG-4: all errors are swallowed into a
      # failure result.
      before do
        allow_any_instance_of(HappyHouse::Leases::Generator)
          .to receive(:generate!).and_raise(StandardError, "kaboom")
      end

      it "returns a failure result without creating a lease" do
        result = nil
        expect { result = described_class.new(params).call }.to_not change(Lease, :count)

        expect(result.success?).to eq(false)
        expect(result.payload).to match(/kaboom/)
      end
    end
  end
end

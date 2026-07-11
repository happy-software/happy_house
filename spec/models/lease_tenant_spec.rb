# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeaseTenant, type: :model do
  it "has a valid factory joining a tenant to a lease" do
    lease_tenant = FactoryBot.create(:lease_tenant)

    expect(lease_tenant).to be_persisted
    expect(lease_tenant.tenant).to be_a(Tenant)
    expect(lease_tenant.lease).to be_a(Lease)
  end
end

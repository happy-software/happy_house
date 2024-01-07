# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tenant, type: :model do
  let(:tenant)    { FactoryBot.create(:tenant) }
  let(:property1) { FactoryBot.create(:property, user: user) }
  let(:property2) { FactoryBot.create(:property, user: user) }
  let(:user)      { FactoryBot.create(:user) }
  let(:lease1)    { FactoryBot.create(:lease, start_date: 2.years.ago, end_date: 1.year.ago, property: property1) }
  let(:lease2)    { FactoryBot.create(:lease, start_date: 1.day.ago, end_date: 1.year.from_now, property: property2) }

  describe '#current_leases' do
    before do
      lease1
      lease2
      FactoryBot.create(:lease_tenant, lease: lease1, tenant: tenant)
      FactoryBot.create(:lease_tenant, lease: lease2, tenant: tenant)
    end

    it 'should return just lease2' do
      expect(tenant.current_leases).to match_array([lease2])
    end
  end

  describe '#current_properties' do
    before do
      lease1
      lease2
      FactoryBot.create(:lease_tenant, lease: lease1, tenant: tenant)
      FactoryBot.create(:lease_tenant, lease: lease2, tenant: tenant)
    end

    it 'should return the current property' do
      expect(tenant.current_properties).to match_array([property2])
    end
  end
end

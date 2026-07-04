# frozen_string_literal: true

require "rails_helper"

RSpec.describe Lease, type: :model do
  let(:record) do
    Lease.new(start_date: start_date, end_date: end_date)
  end

  describe '#expiration_status' do
    subject(:expiration_status) { record.expiration_status }

    before do
      allow(record).to receive(:expired?).and_return(expired)
      allow(record).to receive(:expiring_soon?).and_return(expiring_soon)
      allow(record).to receive(:upcoming?).and_return(upcoming)
    end

    let(:start_date) { Date.today }
    let(:end_date) { Date.tomorrow }
    let(:expired) { false }
    let(:expiring_soon) { false }
    let(:upcoming) { false }

    context 'when lease has expired' do
      let(:expired) { true }
      it { is_expected.to eq(:expired) }
    end

    context 'when lease is expiring soon' do
      let(:expiring_soon) { true }
      it { is_expected.to eq(:expiring_soon) }
    end

    context 'when lease is upcoming' do
      let(:upcoming) { true }
      it { is_expected.to eq(:upcoming) }
    end

    context 'when not expired, expiring soon, or upcoming' do
      it { is_expected.to eq(:current) }
    end
  end

  describe '#expiring_soon?' do
    subject(:expiring_soon?) { record.expiring_soon? }
    context 'when lease expires within 3 months' do
      let(:start_date) { Date.yesterday }
      let(:end_date) { start_date + 3.months }
      it { is_expected.to eq(true) }
    end

    context 'when lease ends after 3 months' do
      let(:start_date) { Date.today }
      let(:end_date) { start_date + 3.months + 1.day }
      it { is_expected.to eq(false) }
    end

    context 'when lease has not started yet' do
      let(:start_date) { Date.tomorrow }
      let(:end_date) { start_date + 1.day }
      it { is_expected.to eq(false)}
    end
  end

  describe '#started?' do
    subject(:started?) { record.started? }

    context 'when lease already started' do
      let(:start_date) { Date.yesterday }
      let(:end_date) { Date.tomorrow }
      it { is_expected.to eq(true) }
    end

    context 'when lease has not started yet' do
      let(:start_date) { Date.tomorrow }
      let(:end_date) { start_date + 1.day }
      it { is_expected.to eq(false) }
    end
  end

  describe '#expired?' do
    subject(:expired?) { record.expired? }

    context 'when lease has already ended' do
      let(:start_date) { end_date - 1 }
      let(:end_date) { Date.yesterday }
      it { is_expected.to eq(true) }
    end

    context 'when lease has not ended yet' do
      let(:start_date) { end_date - 1 }
      let(:end_date) { Date.tomorrow }
      it { is_expected.to eq(false) }
    end
  end

  describe '#upcoming?' do
    subject(:upcoming?) { record.upcoming? }

    context 'when lease has already started' do
      let(:start_date) { Date.yesterday }
      let(:end_date) { Date.tomorrow }
      it { is_expected.to eq(false) }
    end

    context 'when lease has not started yet' do
      let(:start_date) { Date.tomorrow }
      let(:end_date) { start_date + 1 }
      it { is_expected.to eq(true) }
    end
  end

  describe '.active' do
    let!(:past_lease)    { FactoryBot.create(:lease, start_date: 2.years.ago, end_date: 1.year.ago) }
    let!(:current_lease) { FactoryBot.create(:lease, start_date: 1.month.ago, end_date: 11.months.from_now) }
    let!(:future_lease)  { FactoryBot.create(:lease, start_date: 1.month.from_now, end_date: 13.months.from_now) }

    it 'returns only leases active right now by default' do
      expect(Lease.active).to match_array([current_lease])
    end

    it 'accepts an explicit timestamp' do
      expect(Lease.active(18.months.ago)).to match_array([past_lease])
    end
  end

  describe '.build_lease / .build_lease!' do
    let(:property) { FactoryBot.create(:property) }
    let(:tenant)   { FactoryBot.create(:tenant) }
    let(:lease_details) do
      {
        tenants: [tenant],
        starting_date: "2024-01-01",
        ending_date: "2025-01-01",
        rent_amount: 1000,
      }
    end
    let(:fake_pdf) { "%PDF-1.4 fake" }

    before { LeaseFrequency.find_or_create_by!(id: 1) { |lf| lf.frequency = "monthly" } }

    it 'builds an unsaved lease with mapped attributes and an attached contract' do
      lease = Lease.build_lease(property, lease_details, fake_pdf)

      expect(lease).to_not be_persisted
      expect(lease.property).to eq(property)
      expect(lease.tenants).to eq([tenant])
      expect(lease.start_date.to_date).to eq(Date.new(2024, 1, 1))
      expect(lease.end_date.to_date).to eq(Date.new(2025, 1, 1))
      expect(lease.amount).to eq(1000)
      expect(lease.lease_frequency_id).to eq(1)
      expect(lease.contract).to be_attached
      expect(lease.contract.content_type).to eq("application/pdf")
    end

    it 'build_lease! persists the lease' do
      expect { Lease.build_lease!(property, lease_details, fake_pdf) }
        .to change(Lease, :count).by(1)
    end
  end

  describe '.with_eager_loaded_contract' do
    before { LeaseFrequency.find_or_create_by!(id: 1) { |lf| lf.frequency = "monthly" } }

    it 'includes leases and their attached contracts without raising' do
      lease_with_contract = Lease.build_lease!(FactoryBot.create(:property),
                                               { tenants: [], starting_date: "2024-01-01",
                                                 ending_date: "2025-01-01", rent_amount: 1 },
                                               "%PDF-1.4 fake")

      results = Lease.with_eager_loaded_contract.to_a
      expect(results).to include(lease_with_contract)
    end
  end
end

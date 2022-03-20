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
end

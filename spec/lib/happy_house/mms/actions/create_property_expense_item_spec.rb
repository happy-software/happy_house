require 'rails_helper'

describe HappyHouse::MMS::Actions::CreatePropertyExpenseItem do
  let(:instance) { described_class.new(inbound_message) }
  let(:inbound_message) { instance_double(HappyHouse::MMS::InboundMessage,
                                          from:    message_from,
                                          body:    message_body,
                                          sent_at: message_sent_at) }

  let(:message_from) { '+17732025862' }
  let(:message_body) { '14.99 new furnace' }
  let(:message_sent_at) { 1.month.ago }

  describe '#errors' do
    subject { instance.errors }

    context 'without an expense name' do
      let(:message_body) { '14.99' }

      it { is_expected.to include('No expense name or description provided') }
    end

    context 'without a cost' do
      let(:message_body) { 'new kitchen' }

      it { is_expected.to include('Invalid amount provided') }
    end

    context 'when the phone number is an unknown number' do
      let(:message_from) { '+13125551234' }

      it { is_expected.to include('No property found') }
    end
  end

  describe '#perform' do
    let(:property) { Property.create(phone_numbers: [message_from]) }

    it 'creates a new expense item' do
      # instantiate the property
      property.save(validate: false)
      expect { instance.perform }.to change { ExpenseItem.count }.by(1)
    end
  end
end
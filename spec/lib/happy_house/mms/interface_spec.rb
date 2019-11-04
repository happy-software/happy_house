require 'rails_helper'

describe HappyHouse::MMS::Interface do
  let(:expense_number) { '+13120001234' }

  before do
    stub_const('HappyHouse::MMS::Interface::PHONE_NUMBER_FOR_EXPENSES', expense_number)
  end

  describe '.handler_for' do
    let(:inbound_message) { instance_double(HappyHouse::MMS::InboundMessage, to: recipient) }

    context 'when the message is sent to the expense number' do
      let(:recipient) { expense_number }

      it 'calls the create expense action' do
        handler = described_class.handler_for(inbound_message)

        expect(handler).to be_an_instance_of(HappyHouse::MMS::Actions::CreatePropertyExpenseItem)
      end
    end

    context 'when the message is sent to an unhandled number' do
      let(:recipient) { '+10004567890' }

      it 'raises an exception' do
        expect { described_class.handler_for(inbound_message) }.to raise_error(HappyHouse::MMS::Errors::UnhandledNumberError)
      end
    end
  end
end
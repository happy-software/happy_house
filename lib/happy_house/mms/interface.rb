module HappyHouse
  module MMS
    class Interface
      PHONE_NUMBER_FOR_EXPENSES = ENV['PHONE_NUMBER_FOR_EXPENSES'].freeze

      # Processes an inbound message
      #
      # This will determine what kind of message it is and take some actions
      # based on that.
      #
      # @param inbound_message [HappyHouse::MMS::InboundMessage] The message to process
      # @return [nil]
      def self.handler_for(inbound_message)
        case inbound_message.to
          when PHONE_NUMBER_FOR_EXPENSES
            HappyHouse::MMS::Actions::CreatePropertyExpenseItem.new(inbound_message)
          else
            raise HappyHouse::MMS::Errors::UnhandledNumberError, 'Received a message, but did not how to process it'
        end
      end
    end
  end
end

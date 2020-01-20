module HappyHouse
  module MMS
    module Actions
      class CreatePropertyExpenseItem
        # @param inbound_message [HappyHouse::MMS::InboundMessage]
        def initialize(inbound_message)
          @message = inbound_message
        end

        def valid?
          errors.none?
        end

        def errors
          [].tap do |err|
            err << 'No expense name or description provided' unless expense_name.present?
            err << 'Invalid amount provided' unless cost.present? && cost > 0
            err << 'No property found' unless property.present?
          end
        end

        def perform
          raise HappyHouse::MMS::Errors::BadRequestError, errors.join(', ').capitalize unless valid?

          property.expense_items.create(name:         expense_name,
                                        cost:         cost,
                                        expense_date: expense_date)
        end

        private

        attr_reader :message

        def message_body_in_parts
          @message_body_in_parts ||= message.body.split('@').first.split(' ')
        end

        def expense_name
          # Return everything after the first string
          message_body_in_parts.drop(1).join(' ')
        end

        def cost
          message_body_in_parts.first.to_f
        end

        def expense_date
          parsed_date || message.sent_at || Date.current
        end

        def parsed_date
          if date_string = message.body.split('@')[1]
            date = Date.strptime(date_string, '%m/%d')
            # not a valid date
            date = nil if Date.today < date
            date
          end
        end

        def property
          @property ||= Property.find_by("? = ANY(phone_numbers)", message.from)
        end
      end
    end
  end
end
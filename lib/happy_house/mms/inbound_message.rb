# An InboundMessage is an MMS message that was received via an API endpoint
#
# This class represents a generic incoming MMS message, with an adapter to
# MMS providers such as Twilio.
module HappyHouse
  module MMS
    class InboundMessage
      attr_accessor :to, :from, :body, :sent_at, :direction, :media_files, :segment_count

      DIRECTIONS = %i{inbound outbound}.freeze

      def self.from_twilio_payload(payload = {})
        new.tap do |instance|
          instance.sent_at   = if sent_at = payload['date_sent']
                                 Date.rfc2822(sent_at)
                               else
                                 Date.today
                               end
          instance.body      = payload.fetch('body')
          instance.direction = payload.fetch('direction', 'inbound').to_sym
          # If a message is over 160 characters, it is split up into pieces.
          instance.segment_count = payload.fetch('num_segments', 0)
          instance.media_files   = payload.fetch('num_media', 0)
        end
      end
    end
  end
end
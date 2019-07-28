module HappyHouse
  module Leases
    class Generator
      attr_reader :lease_details

      def initialize(lease_details)
        @lease_details = lease_details
      end

      def generate!
        template = get_template
        output = ERB.new(template).result(binding)
      end

      private

      def get_template
        # templates stored in:
        # app/views/leases/templates/lease_type_state.html.erb

        File.open(Rails.root.join('app',
                                  'views',
                                  'leases',
                                  'templates',
                                  "#{lease_type}_#{state}.html.erb")).read
      end

      def state
        lease_details[:property].address['state'].to_s.downcase
      end

      def lease_type
        # Hard coding this for now to work with just standard residential leases
        'standard_residential'
      end
    end
  end
end

module HappyHouse
  module Leases
    class Generator
      attr_reader :lease_details, :pdf, :template

      def initialize(lease_details)
        @lease_details = lease_details.with_indifferent_access
      end

      def generate!
        @template = get_template
        create_pdf!
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

      def create_pdf!
        @output = ERB.new(@template).result(binding)
        @pdf ||= WickedPdf.new.pdf_from_string(@output)
      end

      def state
        lease_details[:state].to_s.downcase
      end

      def lease_type
        # Hard coding this for now to work with just standard residential leases
        'standard_residential'
      end
    end
  end
end

module Leases
  class Renewer

    def initialize(params)
      @params = params
    end

    def call
      property = @params.delete(:property)
      original_lease = @params.delete(:original_lease)
      renewal_details = @params[:lease]

      tenants           = original_lease.tenants
      new_starting_date = renewal_details[:start_date]
      new_ending_date   = renewal_details[:end_date]
      rent_amount       = renewal_details[:amount]

      @lease_details = {
        street_address:       property.address["street_address"],
        city:                 property.address["city"],
        state:                property.address["state"],
        zip_code:             property.address["zip_code"],
        tenants:              tenants,
        starting_date:        new_starting_date&.to_date&.strftime("%B %d, %Y %I:%M %p"),
        ending_date:          new_ending_date&.to_date&.strftime("%B %d, %Y %I:%M %p"),
        rent_amount:          rent_amount,
        lease_creation_date:  Date.current.to_s,
        landlord_name:        property.user.name,
        landlord_email:       property.user.email
      }

      lease_pdf = lease_generator.new(@lease_details).generate!
      @new_lease = Lease.build_lease!(property, @lease_details, lease_pdf)
      OpenStruct.new(success?: true, payload: @new_lease)
    rescue => error
      Rails.logger.error("Error renewing lease: #{error}")
      OpenStruct.new(success?: false, payload: "Error renewing lease: #{error}")
    end

    def lease_generator
      HappyHouse::Leases::Generator
    end
  end
end

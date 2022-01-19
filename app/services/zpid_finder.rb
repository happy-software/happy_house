# frozen_string_literal: true

require "happy_hood/client"

class ZpidFinder
  def initialize(property)
    @property = property
  end

  def get_zpid
    call_api["zpid"]
  end

  private

  def call_api
    HappyHood::Client.new(@property).get_zpid(property_details)
  end

  def property_details
    {
      street_address: @property.address["street_address"],
      state: @property.address["state"],
      city: @property.address["city"],
      zip_code: @property.address["zip_code"]
    }
  end
end

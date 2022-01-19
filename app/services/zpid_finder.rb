require 'happy_hood/client'

class ZpidFinder
  def initialize(property)
    @property = property
  end

  def get_zpid
    call_api.dig('zpid')
  end

  private

  def call_api
    HappyHood::Client.new(@property).get_zpid(property_details)
  end

  def property_details
    {
      street_address: @property.address.dig("street_address"),
      state:          @property.address.dig("state"),
      city:           @property.address.dig("city"),
      zip_code:       @property.address.dig("zip_code"),
    }
  end
end

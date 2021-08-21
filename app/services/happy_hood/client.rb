class HappyHoodService
  attr_reader :zpid, :property

  def initialize(property)
    @property = property
    @zpid     = property.zpid
  end

  def get_history
    make_request(endpoint: :valuations)
  end

  private

  def make_request(endpoint:)
    return {} unless api_path

    case endpoint
    when :valuations
      Rails.cache.fetch("#{Date.today.strftime("%Y-%m-%d")}-#{zpid}") do
        uri = URI("#{api_path}/#{zpid}")
        response = Net::HTTP.get(uri)
        JSON.parse(response).dig('data')
      end
    else
      raise StandardError.new("Unexpected endpoint: #{endpoint}")
    end
  end

  def api_path
    ENV['PRICE_HISTORY_API']
  end
end

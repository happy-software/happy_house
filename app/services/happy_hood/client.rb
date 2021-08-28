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
        req = Net::HTTP::Get.new(uri)
        req['Authorization'] = "Bearer token=\"#{ENV['HAPPY_HOOD_API_TOKEN']}\""

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: Rails.env.production?) { |http| http.request(req) }
        return {} unless response.code.to_i >= 200 && response.code.to_i < 300

        JSON.parse(response.body).dig('data')
      end
    else
      raise StandardError.new("Unexpected endpoint: #{endpoint}")
    end
  end

  def api_path
    ENV['PRICE_HISTORY_API']
  end
end

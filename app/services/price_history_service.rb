class PriceHistoryService
  attr_reader :zpid

  def initialize(zpid)
    @zpid = zpid
  end

  def get_history
    return {} unless zpid
    return {} unless api_path.present?

    resp = call_api
    return {} unless resp.code.to_i == 200

    JSON.parse(resp.body).dig('data')
  end

  private

  def call_api
    Rails.cache.fetch("#{Date.today.strftime("%Y-%m-%d")}-#{zpid}") do
      uri = URI("#{api_path}/#{zpid}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Get.new(uri.path)
      http.request(req)
    end
  end

  def api_path
    ENV['PRICE_HISTORY_API']
  end
end

class PriceHistoryService
  attr_reader :zpid

  def initialize(zpid)
    @zpid = zpid
  end

  def get_history
    return {} unless zpid
    return {} unless ENV['PRICE_HISTORY_API'].present?

    resp = call_api
    return {} unless resp.code.to_i == 200

    JSON.parse(resp.body).dig('data')
  end

  private

  def call_api

    uri = URI("#{ENV['PRICE_HISTORY_API']}/#{zpid}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Get.new(uri.path)
    http.request(req)
  end
end

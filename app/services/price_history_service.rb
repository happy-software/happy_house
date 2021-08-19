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

    raw_data = JSON.parse(resp.body).dig('data')
    monthly_summary(raw_data)
  end

  private

  def call_api
    Rails.cache.fetch("#{Date.today.strftime("%Y-%m-%d")}-#{zpid}") do
      uri = URI("#{api_path}/#{zpid}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = Rails.env.production? # Turn SSL off for local testing

      req = Net::HTTP::Get.new(uri.path)
      http.request(req)
    end
  end

  def api_path
    ENV['PRICE_HISTORY_API']
  end

  def monthly_summary(raw_data)
    totals_by_month = Hash.new.tap do |monthly|
      raw_data.each do |date, amount|
        monthly[date.first(7)] ||= []
        monthly[date.first(7)] << amount.to_f
      end
    end

    summarized = {}
    totals_by_month.each do |date, amounts|
      display_month = "#{Date::MONTHNAMES[date.last(2).to_i]} #{date.first(4)}"
      summarized[display_month] = (amounts.sum / amounts.count).round(2)
    end

    summarized
  end
end

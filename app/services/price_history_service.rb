require 'happy_hood/client'

class PriceHistoryService
  attr_reader :zpid

  def initialize(property)
    @property = property
    @zpid = property.zpid
  end

  def get_history
    return {} unless zpid

    resp = call_api
    return {} unless resp.code.to_i == 200

    raw_data = JSON.parse(resp.body).dig('data')
    monthly_summary(raw_data)
  end

  private
  def call_api
    HappyHoodService.new(property).get_history
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

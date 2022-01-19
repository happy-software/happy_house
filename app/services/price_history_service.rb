require 'happy_hood/client'

# Gets you the price history for a give property
class PriceHistoryService
  attr_reader :zpid, :property

  def initialize(property)
    @property = property
    @zpid = property.zpid
  end

  def get_history
    return {} unless zpid
    monthly_summary(call_api)
  end

  private

  def call_api
    HappyHood::Client.new(property).get_history
  end

  def monthly_summary(raw_data)
    totals_by_month = Hash.new.tap do |monthly|
      raw_data.each do |date, amount|
        clean_date = date.to_s.first(7)
        monthly[clean_date] ||= []
        monthly[clean_date] << amount.to_f
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

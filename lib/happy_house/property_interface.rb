require 'happy_house/taxes/expense_reports/builder'

module HappyHouse
  class PropertyInterface
    attr_reader :property

    def initialize(property)
      @property = property
    end

    def build_expense_report(year: Date.current.year)
      HappyHouse::Taxes::ExpenseReports::Builder.new(property).build_for_year(year)
    end

    def expense_years
      property.expense_items.map { |e| e.expense_date.year }.uniq.sort
    end
  end
end

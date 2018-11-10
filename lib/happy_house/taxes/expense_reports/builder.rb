module HappyHouse
  module Taxes
    module ExpenseReports
      class Builder
        attr_reader :property

        def initialize(property)
          @property = property
        end

        def build_for_year(year)
          expense_items_in_year(year).map do |expense_item|
            {
              name: expense_item.name,
              cost: expense_item.cost,
              date: expense_item.expense_date,
            }
          end
        end

        private

        def expense_items_in_year(year)
          @expense_reports ||= property.expense_items.where("extract(year from expense_date) = ?", year)
        end
      end
    end
  end
end

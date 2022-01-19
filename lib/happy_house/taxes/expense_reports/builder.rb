# frozen_string_literal: true

module HappyHouse
  module Taxes
    module ExpenseReports
      class Builder
        attr_reader :property

        def initialize(property)
          @property = property
        end

        def build_for_year(year)
          expenses = property.expense_items.for_year(year).order(:expense_date)
          total_cost = expenses.map { |e| e[:cost] }.sum
          items = expenses.map do |expense_item|
            {
              id: expense_item.id,
              name: expense_item.name,
              cost: expense_item.cost,
              date: expense_item.expense_date
            }
          end

          {
            total_cost: total_cost,
            expenses: items
          }
        end
      end
    end
  end
end

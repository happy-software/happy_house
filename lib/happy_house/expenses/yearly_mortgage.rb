module HappyHouse
  module Expenses
    class YearlyMortgage
      def self.create_new_mortgage_payments!(property, year, amount)
        ExpenseItem.create_yearly_mortgage_payments!(property, year, amount)
      end
    end
  end
end

module HappyHouse
  module Expenses
    class YearlyMortgage
      def self.create_new_mortgage_payments!(property, year, amount)
        puts "Time to create 12 payments of #{amount} on the first of each month for a #{year}"
      end
    end
  end
end

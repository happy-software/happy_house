# frozen_string_literal: true

module ExpenseItemHelpers
  module OneOffUploaders
    #########################################################################
    # These are one off methods I created to load things into the db through#
    # console instead of trying to create a UI for it.                      #
    #########################################################################
    def create_yearly_mortgage_payments!(property, year, amount)
      (1..12).each do |month|
        name = "#{month}-#{year} Mortgage Payment"
        cost = amount
        expense_date = DateTime.parse("#{year}-#{month}-01")

        ExpenseItem.create!(name: name, cost: cost, expense_date: expense_date, property: property)
      end
    end

    def create_yearly_hoa_payments!(property, year, amount)
      (1..12).each do |month|
        name = "#{month}-#{year} HOA Payment"
        cost = amount
        expense_date = DateTime.parse("#{year}-#{month}-01")

        ExpenseItem.create!(name: name, cost: cost, expense_date: expense_date, property: property)
      end
    end
  end
end

class ExpenseItem < ApplicationRecord
  belongs_to :property

  validates :name,  presence: true
  validates :cost,  presence: true
  validates :expense_date, presence: true

  def self.create_yearly_mortgage_payments!(property, year, amount)
    puts "Time to create 12 payments of #{amount} on the first of each month for #{year}"
    (1..12).each do |month|
      name = "#{month}-#{year} Mortgage Payment"
      cost = amount
      expense_date = DateTime.parse("#{year}-#{month}-01")

      ExpenseItem.new.tap do |item|
        item.name = name
        item.cost = cost
        item.expense_date = expense_date
        item.property = property
        item.save!
      end
    end
  end
end

class ExpenseItem < ApplicationRecord
  belongs_to :property

  validates :name,  presence: true
  validates :cost,  presence: true
  validates :expense_date, presence: true
end

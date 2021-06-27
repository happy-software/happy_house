require 'expense_item/one_off_uploaders'
class ExpenseItem < ApplicationRecord
  extend OneOffUploaders

  belongs_to :property

  validates :name,  presence: true
  validates :cost,  presence: true
  validates :expense_date, presence: true

  has_many_attached :attachments

  scope :for_year, -> (year) { where("extract(year from expense_date) = ?", year).order(:expense_date) }
end

# frozen_string_literal: true

require "expense_item_helpers/one_off_uploaders"
class ExpenseItem < ApplicationRecord
  extend ExpenseItemHelpers::OneOffUploaders

  belongs_to :property
  has_rich_text :notes

  validates :name,  presence: true
  validates :cost,  presence: true
  validates :expense_date, presence: true

  has_many_attached :attachments

  scope :for_year, ->(year) { where("extract(year from expense_date) = ?", year) }
end

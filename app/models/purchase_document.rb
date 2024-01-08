class PurchaseDocument < ApplicationRecord
  belongs_to :property
  has_one_attached :document
  has_rich_text :notes

  validates :title,    presence: true
  validates :document, presence: true
end

# frozen_string_literal :true

class InsuranceDocument < ApplicationRecord
  belongs_to :property
  has_one_attached :document

  validates :title,    presence: true
  validates :document, presence: true
end

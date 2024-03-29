# frozen_string_literal: true

# TODO: Can delete this model, it's not actually used anywhere
class PropertyDocument < ApplicationRecord
  belongs_to :property
  belongs_to :property_document_type
  has_one :lease
  has_one_attached :document

  accepts_nested_attributes_for :property_document_type, allow_destroy: false
end

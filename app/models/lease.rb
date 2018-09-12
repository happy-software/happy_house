class Lease < ApplicationRecord
  has_and_belongs_to_many :tenants
  belongs_to :property_document
  has_one :property, through: :property_document
end

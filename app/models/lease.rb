class Lease < ApplicationRecord
  has_and_belongs_to_many :tenants
  belongs_to :property_document
end

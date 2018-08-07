class Property < ApplicationRecord
  belongs_to :user

  PROPERTY_TYPES = [:townhome, :single_family_home, :apartment, :condo, :commercial]
  validates :property_type, presence: true
  validates_inclusion_of :property_type, :in => PROPERTY_TYPES.map(&:to_s).map(&:titleize)
end

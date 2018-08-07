class Property < ApplicationRecord
  belongs_to :user

  validates_presence_of :property_type
  PROPERTY_TYPES = [:townhome, :single_family_home, :apartment, :condo, :commercial]
end

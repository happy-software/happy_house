class Property < ApplicationRecord
  enum property_type: { townhome: 0, single_family_home: 1, condo: 2, apartment: 3, commercial: 4 }
  belongs_to :user
end

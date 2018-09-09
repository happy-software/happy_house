class Lease < ApplicationRecord
  belongs_to :tenants
  belongs_to :property
end

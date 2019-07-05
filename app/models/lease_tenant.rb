class LeaseTenant < ApplicationRecord
  belongs_to :tenant
  belongs_to :lease
end

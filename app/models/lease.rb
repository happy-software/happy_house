class Lease < ApplicationRecord
  has_and_belongs_to_many :tenants
  belongs_to :property_document
  has_one :property, through: :property_document
  belongs_to :lease_frequency

  def expired?(date=nil)
    date = date || DateTime.now
    return unless self.end_date
    date > self.end_date
  end

  def expiring_soon?
    !expired? && expired?(Date.today + 3.months)
  end

  def expiration_status
    return :expired if expired?
    return :expiring_soon if expiring_soon?

    :current
  end
end

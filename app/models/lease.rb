class Lease < ApplicationRecord
  has_and_belongs_to_many :tenants
  belongs_to :property_document
  has_one :property, through: :property_document

  def expired?(date=nil)
    date = date || DateTime.now
    return unless self.end_date
    date > self.end_date
  end
end

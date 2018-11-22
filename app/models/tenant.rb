class Tenant < ApplicationRecord
  has_and_belongs_to_many :leases
  has_many :property_documents, through: :leases

  def current_leases
    self.leases.select do |lease|
      lease.start_date >= Time.now && lease.end_date <= Time.now
    end
  end

  def current_properties
    current_leases.map(&:property)
  end

end
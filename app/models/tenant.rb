# frozen_string_literal: true

class Tenant < ApplicationRecord
  has_many :lease_tenants
  has_many :leases, through: :lease_tenants
  has_many :property_documents, through: :leases

  def current_leases
    leases.select(&:started?)
  end

  def current_properties
    current_leases.map(&:property)
  end
end

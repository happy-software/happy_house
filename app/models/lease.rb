class Lease < ApplicationRecord
  # A lease is a document between a landlord and tenant that outlines an agreement for the renting of property or space.
  # A lease will detail the monthly rent, property description, and responsibilities of each of the party.
  # During the course of the lease, if the landlord or tenant violates any of its terms they could default and be
  # liable for damages to the other party.
  #
  # There are 5 common lease types:
  #   1. Commercial
  #   2. Month-to-Month Rental Agreement
  #   3. Roommate Lease
  #   4. Standard Residential Lease Agreement
  #   5. Sub-Lease Agreement
  belongs_to :lease_type
  belongs_to :lease_frequency

  belongs_to :property

  has_one_attached :contract
  has_many :lease_tenants
  has_many :tenants, through: :lease_tenants

  accepts_nested_attributes_for :lease_tenants

  # Eager loaded queries ensure that the relationships are established
  #
  # Ensure that we are able to load contracts that have an attached contract
  # in a single query, as opposed to n+1 queries
  # https://semaphoreci.com/blog/2017/08/09/faster-rails-eliminating-n-plus-one-queries.html
  scope :with_eager_loaded_contract, -> { eager_load(contract_attachment: :blob) }

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

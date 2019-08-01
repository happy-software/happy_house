class Lease < ApplicationRecord
  belongs_to :property
  belongs_to :lease_frequency

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

  def self.build_lease!(property, lease_details)
    l = Lease.new
    l.property = property
    l.tenants  = lease_details[:tenants]
    l.start_date = lease_details[:start_date]
    l.end_date   = lease_details[:end_date]
    # TODO Still need to attach document somehow
  end

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

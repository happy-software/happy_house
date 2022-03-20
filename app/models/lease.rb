# frozen_string_literal: true

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

  def self.build_lease!(property, lease_details, lease_pdf)
    l = build_lease(property, lease_details, lease_pdf)
    l.save!
    l
  end

  def self.build_lease(property, lease_details, lease_pdf)
    l = Lease.new
    l.property = property
    l.tenants  = lease_details[:tenants]
    l.start_date = lease_details[:starting_date]
    l.amount     = lease_details[:rent_amount]
    l.end_date   = lease_details[:ending_date]
    l.lease_frequency_id = 1 # hardcoding just to get it working for now, I was having some weird error pop up
    l.contract.attach(io: StringIO.new(lease_pdf), filename: "lease_#{l.start_date}_#{Date.current}",
                      content_type: "application/pdf")
    l
  end

  def self.active(timestamp = DateTime.now)
    where("start_date <= ? AND end_date >= ?", timestamp, timestamp)
  end

  def expired?(date = nil)
    date ||= DateTime.now
    return unless end_date

    date > end_date
  end

  def expiring_soon?
    return false unless started?
    !expired? && expired?(Date.today + 3.months)
  end

  def started?(date = Date.today)
    (self.start_date <= date) && !expired?
  end

  def upcoming?(date = Date.today)
    self.start_date > date
  end

  def expiration_status
    return :expired if expired?
    return :expiring_soon if expiring_soon?
    return :upcoming if upcoming?

    :current
  end
end

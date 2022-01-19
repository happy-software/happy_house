# frozen_string_literal: true

require "happy_house/property_interface"

class Property < ApplicationRecord
  belongs_to :user
  has_many :leases
  has_many :tenants, through: :leases
  has_many :utility_accounts
  has_many :expense_items
  has_many :events

  accepts_nested_attributes_for :leases, allow_destroy: true
  # has_many_attached :documents

  # accepts_nested_attributes_for :property_documents, allow_destroy: true

  PROPERTY_TYPES = %i[townhome single_family_home apartment condo commercial].freeze
  validates :property_type, presence: true
  validates_inclusion_of :property_type, in: PROPERTY_TYPES.map(&:to_s).map(&:titleize)

  scope :townhomes,           -> { where(property_type: "Townhome") }
  scope :single_family_homes, -> { where(property_type: "Single Family Home") }
  scope :apartments,          -> { where(property_type: "Apartment") }
  scope :condos,              -> { where(property_type: "Condo") }
  scope :commercials,         -> { where(property_type: "Commercial") }

  def display_name
    nickname.blank? ? address["street_address"] : nickname
  end

  def property_interface
    @property_interface ||= HappyHouse::PropertyInterface.new(self)
  end

  def expense_years
    expense_items.pluck(:expense_date).map(&:year).uniq.sort.reverse!
  end
end

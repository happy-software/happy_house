require 'happy_house/property_interface'

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

  PROPERTY_TYPES = [:townhome, :single_family_home, :apartment, :condo, :commercial]
  validates :property_type, presence: true
  validates_inclusion_of :property_type, :in => PROPERTY_TYPES.map(&:to_s).map(&:titleize)

  scope :townhomes,           -> { where(property_type: 'Townhome') }
  scope :single_family_homes, -> { where(property_type: 'Single Family Home') }
  scope :apartments,          -> { where(property_type: 'Apartment') }
  scope :condos,              -> { where(property_type: 'Condo') }
  scope :commercials,         -> { where(property_type: 'Commercial') }


  def display_name
    self.nickname.blank? ? self.address['street_address'] : self.nickname
  end

  def property_interface
    @property_interface ||= HappyHouse::PropertyInterface.new(self)
  end

end

class PropertyDocument < ApplicationRecord
  attr_accessor :type, :name, :document
  belongs_to :property
  has_one_attached :document
end

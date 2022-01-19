# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    address { "" }
    property_type { Property::PROPERTY_TYPES.sample.to_s.titleize }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    address { {"city"=>"Smiles City", "state"=>"Joyfulness", "zip_code"=>"12345", "street_address"=>"123 Happy St."} }
    property_type { Property::PROPERTY_TYPES.first.to_s.titleize }
    nickname { "Happy Factory House" }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :expense_item do
    property
    name { "MyString" }
    cost { "9.99" }
    expense_date { Date.new(2024, 6, 15) }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :expense_item do
    name { "MyString" }
    cost { "9.99" }
    expense_date { "2018-11-09 21:44:30" }
  end
end

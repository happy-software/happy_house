# frozen_string_literal: true

FactoryBot.define do
  factory :lease do
    property
    start_date { 1.month.ago }
    end_date { 11.months.from_now }
    amount { 1500.00 }
    details { "" }
    lease_frequency { FactoryBot.create(:lease_frequency) }
  end
end

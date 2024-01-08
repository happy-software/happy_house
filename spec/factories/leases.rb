# frozen_string_literal: true

FactoryBot.define do
  factory :lease do
    start_date { "2019-06-15 16:51:51" }
    end_date { "2019-06-15 16:51:51" }
    details { "" }
    lease_frequency { FactoryBot.create(:lease_frequency) }
  end
end

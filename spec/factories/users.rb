# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    trait :activated do
      activated { true }
      activated_at { Time.zone.now }
    end
  end
end

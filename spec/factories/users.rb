FactoryBot.define do
  factory :user do
    name {'Tony Stark'}
    email {'tony.stark@starkindustries.com'}
    password {'password'}
    password_confirmation {'password'}
  end
end

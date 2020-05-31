FactoryBot.define do
  factory :merchant do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    name { 'マルナカ' }
  end
end

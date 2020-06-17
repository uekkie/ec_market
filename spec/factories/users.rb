FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    after(:create) do |user|
      user.shipping_address = create(:shipping_address, user: user)
    end
  end

  factory :admin, class: User do
    sequence(:email) { |n| "admin@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }
  end
end

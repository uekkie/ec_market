FactoryBot.define do
  factory :comment do
    user { nil }
    item { nil }
    body { "MyText" }
  end
end

FactoryBot.define do
  factory :post do
    user { create(:user) }
    title { "サンプルポスト" }
    content { "本文サンプル" }
  end
end

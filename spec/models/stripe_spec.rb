require 'rails_helper'

RSpec.describe StripeMock, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }

  let!(:user) { create(:user) }
  let!(:item) { create(:item) }

  let!(:build_order) {
    build(:order, user: user, merchant: item.merchant) do |order|
      order.order_items.build(item: item, quantity: 2)
      order.purchased_type = :credit_card
    end
  }

  before { StripeMock.start }
  after { StripeMock.stop }

  it 'ユーザーのstripe情報が更新されること' do
    expect(user.attach_customer(stripe_helper.generate_card_token)).to be_truthy
    expect(user.stripe_customer_id).to_not be_blank
  end

  it "クレジットカード決済が成功すること" do
    expect {
      expect(build_order.save_and_charge(false, stripe_helper.generate_card_token)).to be_truthy
      expect(build_order.user.stripe_customer_id).to_not be_empty
    }.to change { Order.count }.by(1)
  end

  it "カードが不正なとき、注文が失敗すること" do
    StripeMock.prepare_card_error(:card_declined)

    prev_stripe_id = build_order.user.stripe_customer_id

    expect {
      expect(build_order.save_and_charge(false, stripe_helper.generate_card_token)).to be_falsey
      expect(build_order.errors[:base].first).to eq 'Stripeでの決済に失敗しました。カード情報を確認してください。'
    }.to change { Order.count }.by(0)
    user.reload
    expect(user.stripe_customer_id).to eq prev_stripe_id
  end

  it "以前と同じカードで決済できること" do

    build_order.user.update!(stripe_customer_id: Stripe::Customer.create(
      email: user.email,
      source: stripe_helper.generate_card_token
    ).id)

    expect {
      expect(build_order.save_and_charge(true, stripe_helper.generate_card_token)).to be_truthy
    }.to change { Order.count }.by(1)
  end
end

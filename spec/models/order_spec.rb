require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:merchant) { create(:merchant) }
  let!(:item) { create(:item) }

  let!(:order) {
    create(:order, user: user, merchant: merchant) do |order|
      order.order_items.create(item: item, quantity: 2)
    end
  }

  describe '注文のステータス' do
    it '作成後は「注文済み」になる' do
      expect(order.status).to eq 'ordered'
    end

    context '業者がステータスを更新したとき' do

      it '発送準備にすると「発送処理中」になる' do
        merchant.prepare_shipping(order)
        expect(order.status).to eq 'prepare_shipping'
      end

      it '発送すると「発送済み」になる' do
        merchant.shipped(order)
        expect(order.status).to eq 'shipped'
      end

      it 'キャンセル「キャンセル」になる' do
        merchant.cancel(order)
        expect(order.status).to eq 'canceled'
      end
    end

  end

  describe '送料' do
    it '業者Aは5商品ごとに600円の送料が発生する' do
      merchant_a = create(:merchant, quantity_per_box: 5)

      order = create(:order, user: user, merchant: merchant_a) do |order|
        order.order_items.create(item: item, quantity: 6)
      end

      expect(order.postage).to eq 1200
      expect(order.total_with_tax).to eq 3560
    end

    it '業者Bは8商品ごとに600円の送料が発生する' do
      merchant_b = create(:merchant, quantity_per_box: 8)

      order1 = create(:order, user: user, merchant: merchant_b) do |order|
        order.order_items.create(item: item, quantity: 6)
      end

      expect(order1.postage).to eq 600
      expect(order1.total_with_tax).to eq 2920

      order2 = create(:order, user: user, merchant: merchant_b) do |order|
        order.order_items.create(item: item, quantity: 9)
      end

      expect(order2.postage).to eq 1200
      expect(order2.total_with_tax).to eq 4540
    end
  end

  describe '代引き手数料' do
    it '商品代金に応じて手数料が上がる' do
      item = create(:item, price: 1000)
      order_for_fee = create(:order, user: user, merchant: merchant) do |order|
        order.order_items.create(item: create(:item, price: 1000), quantity: 10)
      end
      expect(order_for_fee.subtotal).to eq 10_000
      expect(order_for_fee.delivery_fee).to eq 400

      order_for_fee.order_items.create(item: item, quantity: 20)
      expect(order_for_fee.subtotal).to eq 30_000
      expect(order_for_fee.delivery_fee).to eq 600

      order_for_fee.order_items.create(item: item, quantity: 70)
      expect(order_for_fee.subtotal).to eq 100_000
      expect(order_for_fee.delivery_fee).to eq 1000
    end

    it 'クレジットカード払いは代引き手数料がかからない' do
      order.purchased_type = :credit_card
      expect(order.delivery_fee).to eq 0
    end
  end

  describe 'Stripe決済' do
    let(:stripe_helper) { StripeMock.create_test_helper }

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

    describe 'Order::Checkout' do
      it 'success #Checkout.create!' do
        customer = Stripe::Customer.create(
          email: user.email,
          source: stripe_helper.generate_card_token
        )
        expect(Order::Checkout.create!(user: user, order: build_order, customer: customer)).to eq true
      end

      it 'failed #Checkout.create!' do
        StripeMock.prepare_card_error(:card_declined)

        customer = Stripe::Customer.create(
          email: user.email,
          source: stripe_helper.generate_card_token
        )
        expect {
          Order::Checkout.create!(user: user, order: build_order, customer: customer)
        }.to raise_error(Stripe::CardError)
      end
    end

    describe '#save_and_charge' do
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
  end
end

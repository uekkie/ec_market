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
end

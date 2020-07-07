require 'rails_helper'

RSpec.describe Cart, type: :model do
  it '業者でフィルタリング' do
    cart = Cart.new

    merchant_a = create(:merchant, name: 'merchant_a')
    merchant_b = create(:merchant, name: 'merchant_b')
    cart.cart_items.build(item: create(:item, name: 'itemA', price: 300, merchant: merchant_a))
    cart.cart_items.build(item: create(:item, name: 'itemB', price: 400, merchant: merchant_a))
    cart.cart_items.build(item: create(:item, name: 'itemC', price: 500, merchant: merchant_b))

    cart.save

    expect(cart.filtered_merchant_id(merchant_a.id).count).to eq 2
    expect(cart.filtered_merchant_id(merchant_b.id).count).to eq 1
  end
end

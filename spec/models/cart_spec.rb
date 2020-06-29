require 'rails_helper'

RSpec.describe Cart, type: :model do
  it '業者でフィルタリング' do
    cart = Cart.new

    merchantA = create(:merchant, name: 'merchantA')
    merchantB = create(:merchant, name: 'merchantB')
    cart.cart_items.build(item: create(:item, name: 'itemA', price: 300, merchant: merchantA))
    cart.cart_items.build(item: create(:item, name: 'itemB', price: 400, merchant: merchantA))
    cart.cart_items.build(item: create(:item, name: 'itemC', price: 500, merchant: merchantB))

    cart.save

    expect(cart.filtered_merchant_id(merchantA.id).count).to eq 2
    expect(cart.filtered_merchant_id(merchantB.id).count).to eq 1
  end
end

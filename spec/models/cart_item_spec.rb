require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:product) { create(:product) }
  let(:cart) { create(:cart) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      cart_item = build(:cart_item, cart: cart, product: product)
      expect(cart_item).to be_valid
    end

    it 'is invalid with a quantity less than 1' do
      cart_item = build(:cart_item, cart: cart, product: product, quantity: 0)
      expect(cart_item).to_not be_valid
    end

    it 'is invalid with a negative unit_price' do
      cart_item = build(:cart_item, cart: cart, product: product, unit_price: -1)
      expect(cart_item).to_not be_valid
    end

    it 'is invalid without a total_price' do
      cart_item = build(:cart_item, cart: cart, product: product, total_price: nil)
      expect(cart_item).to_not be_valid
    end

    it 'is invalid with a negative total_price' do
      cart_item = build(:cart_item, cart: cart, product: product, total_price: -1)
      expect(cart_item).to_not be_valid
    end
  end

  describe 'callbacks' do
    it 'calculates the unit_price and total_price before save' do
      cart_item = build(:cart_item, cart: cart, product: product, quantity: 2)
      expect(cart_item.unit_price).to eq(product.price)
      expect(cart_item.total_price).to eq(product.price * 2)
    end
  end

  describe 'associations' do
    it 'belongs to a cart' do
      cart_item = build(:cart_item)
      expect(cart_item.cart).to be_a(Cart)
    end

    it 'belongs to a product' do
      cart_item = build(:cart_item)
      expect(cart_item.product).to be_a(Product)
    end
  end
end

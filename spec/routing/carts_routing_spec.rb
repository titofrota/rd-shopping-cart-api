require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'routes to #add_product' do
      expect(post: '/cart').to route_to('carts#add_product')
    end

    it 'routes to #add_item' do
      expect(post: '/cart/add_item').to route_to('carts#add_item')
    end

    it 'routes to #remove_item' do
      expect(delete: '/cart/:product_id').to route_to('carts#remove_item', product_id: ':product_id')
    end
  end
end

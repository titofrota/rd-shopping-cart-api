require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let(:product) { Product.create(name: "Test Product", price: 10.0) }
  let(:new_product) { Product.create(name: "New Product", price: 20.0) }
  let(:cart) { Cart.create }

  before do
    allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })
  end

  describe "POST /cart" do
    context 'when the product is not in the cart' do
      subject do
        post '/cart', params: { cart: { product_id: new_product.id, quantity: 1 } }, as: :json
      end

      it 'adds the product to the cart' do
        expect(cart.cart_items.exists?(product_id: new_product.id)).to be_falsey
        expect { subject }.to change { cart.reload.cart_items.count }.by(1)
        expect(cart.cart_items.first.quantity).to eq(1)

        json_response = JSON.parse(response.body)

        expect(json_response['products'].any? { |item| item['id'] == new_product.id }).to be_truthy
        expect(json_response['total_price'].to_f).to eq(new_product.price.to_f)
      end
    end

    context 'when the product is already in the cart' do
      let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

      subject do
        post '/cart', params: { cart: { product_id: product.id, quantity: 2 } }, as: :json
      end

      it 'updates the quantity of the existing product in the cart' do
        expect(cart.cart_items.exists?(product_id: product.id)).to be_truthy
        expect { subject }.to change { cart_item.reload.quantity }.from(1).to(3)

        json_response = JSON.parse(response.body)

        updated_product = json_response['products'].find { |item| item['id'] == product.id }
        expect(updated_product['quantity']).to eq(3)
        expect(json_response['total_price'].to_f).to eq(30.0)
      end
    end

    context 'when the product does not exist' do
      subject do
        post '/cart', params: { cart: { product_id: 999, quantity: 1 } }, as: :json
      end

      it 'returns an error if the product is not found' do
        subject
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq('Product not found')
        expect(response.status).to eq(404)
      end
    end

    context 'when the quantity is invalid (less than 1)' do
      subject do
        post '/cart', params: { cart: { product_id: product.id, quantity: 0 } }, as: :json
      end

      it 'returns an error if the quantity is less than 1' do
        subject
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq('Unable to save cart item')
        expect(response.status).to eq(422)
      end
    end

    context 'when the cart is not found in session' do
      before do
        allow_any_instance_of(CartsController).to receive(:session).and_return({})
      end

      subject do
        post '/cart', params: { cart: { product_id: new_product.id, quantity: 1 } }, as: :json
      end

      it 'creates a new cart and adds the product' do
        expect { subject }.to change { Cart.count }.by(1)
      
        cart = Cart.last
      
        expect(cart.cart_items.reload.count).to eq(1)
        expect(cart.cart_items.reload.first.product_id).to eq(new_product.id)
      end
    end
  end

  describe "GET /cart" do
    context 'when the cart exists' do
      let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

      subject do
        get '/cart', as: :json
      end

      it 'returns the cart with its items' do
        subject
        json_response = JSON.parse(response.body)

        expect(json_response['id']).to eq(cart.id)
        expect(json_response['products'].any? { |item| item['id'] == product.id }).to be_truthy
      end
    end

    context 'when the cart is empty' do
      subject do
        get '/cart', as: :json
      end
    
      it 'returns an empty cart with zero total price' do
        subject
        json_response = JSON.parse(response.body)
        
        expect(json_response['products']).to be_empty
        expect(json_response['total_price'].to_f).to eq(0.0)
      end
    end
  end

  describe "POST /add_item" do
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_item', params: { cart: { product_id: product.id, quantity: 1 } }, as: :json
        post '/cart/add_item', params: { cart: { product_id: product.id, quantity: 1 } }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end

  describe "DELETE /cart/:product_id" do
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product is in the cart' do
      subject do
        delete "/cart/#{product.id}", as: :json
      end

      it 'removes the product from the cart' do
        expect { subject }.to change { cart.cart_items.count }.by(-1)
        expect(cart.cart_items.exists?(product_id: product.id)).to be_falsey

        json_response = JSON.parse(response.body)

        expect(json_response['products'].any? { |item| item['id'] == product.id }).to be_falsey
        expect(json_response['total_price'].to_f).to eq(0.0)
      end
    end

    context 'when trying to remove a product not in the cart' do
      subject do
        delete "/cart/999", as: :json
      end

      it 'returns an error' do
        subject
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq('Product not found')
        expect(response.status).to eq(404)
      end
    end

    context 'when removing the last item from the cart' do
      let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }
    
      subject do
        delete "/cart/#{product.id}", as: :json
      end
    
      it 'resets total price to zero' do
        expect(cart.cart_items.exists?(product_id: product.id)).to be_truthy
        
        subject
    
        json_response = JSON.parse(response.body)

        expect(json_response['total_price'].to_f).to eq(0.0)
        expect(json_response['products']).to be_empty
        expect(cart.cart_items.count).to eq(0)
        expect(cart.total_price).to eq(0.0)
      end
    end
  end
end

class CartsController < ApplicationController
  before_action :set_cart, only: %i[add_product show]
  before_action :set_product, only: %i[add_product]
  before_action :set_cart_service, only: %i[add_product]

  # POST /cart
  def add_product
    added_product = @cart_service.add_product(@product, cart_params[:quantity])

    if added_product
      render json: {
        id: @cart.id,
        products: @cart.cart_items.map { |item| {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.quantity * item.product.price
        }},
        total_price: @cart.total_price
      }, status: :ok
    else
      render json: { error: 'Unable to add product to cart' }, status: :unprocessable_entity
    end
  end

  # GET /cart
  def show
    if @cart.persisted?
      render json: {
        id: @cart.id,
        products: @cart.cart_items.map { |item| {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.quantity * item.product.price
        }},
        total_price: @cart.total_price
      }, status: :ok
    else
      render json: { error: 'Cart not found' }, status: :not_found
    end
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by(id: session[:cart_id])
    session[:cart_id] ||= @cart.id
  end  

  def set_product
    @product = Product.find_by(id: cart_params[:product_id])
    
    unless @product
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def set_cart_service
    @cart_service = CartService.new(@cart)
  end

  def cart_params
    params.require(:cart).permit(:product_id, :quantity)
  end
end

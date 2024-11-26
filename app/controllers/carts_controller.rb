class CartsController < ApplicationController
  before_action :set_cart
  before_action :set_product, only: %i[add_product add_item remove_item]
  before_action :set_cart_service

  def add_product
    @cart_service.add_product(@product, cart_params[:quantity])
    render_cart
  rescue CartService::UnableToSaveCartItemError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def show
    render_cart
  end

  def add_item
    @cart_service.add_item(@product, cart_params[:quantity])
    render_cart
  rescue CartService::UnableToSaveCartItemError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def remove_item
    @cart_service.remove_item(@product)
    render_cart
  rescue CartService::ProductNotFoundError => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def render_cart
    render json: @cart_service.cart_payload, status: :ok
  end

  def set_cart
    @cart = Cart.find_or_create_by(id: session[:cart_id])
    session[:cart_id] ||= @cart.id
  end  

  def set_product
    @product = Product.find_by(id: cart_params[:product_id] || params[:product_id])
    render json: { error: 'Product not found' }, status: :not_found unless @product
  end

  def set_cart_service
    @cart_service = CartService.new(@cart)
  end

  def cart_params
    params.fetch(:cart, {}).permit(:product_id, :quantity)
  end  
end
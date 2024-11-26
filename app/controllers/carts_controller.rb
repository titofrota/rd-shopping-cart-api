class CartsController < ApplicationController
  before_action :set_cart, only: %i[add_product show add_item remove_item]
  before_action :set_product, only: %i[add_product add_item remove_item]
  before_action :set_cart_service, only: %i[add_product show add_item remove_item]

  # POST /cart
  def add_product
    added_product = @cart_service.add_product(@product, cart_params[:quantity])

    if added_product
      render_cart
    else
      render json: { error: 'Unable to add product to cart' }, status: :unprocessable_entity
    end
  end

  # GET /cart
  def show
    if @cart.persisted?
      render_cart
    else
      render json: { error: 'Cart not found' }, status: :not_found
    end
  end

  # POST /cart/add_item
  def add_item
    added_product = @cart_service.add_item(@product, cart_params[:quantity])

    if added_product
      render_cart
    else
      render json: { error: 'Unable to add item to cart' }, status: :unprocessable_entity
    end
  end

  # DELETE /cart/:product_id
  def remove_item
    removed_product = @cart_service.remove_item(@product)

    if removed_product
      render_cart
    else
      render json: { error: 'Unable to remove product from cart' }, status: :unprocessable_entity
    end
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
    product_id = cart_params[:product_id] || params[:product_id]
    @product = Product.find_by(id: product_id)

    render json: { error: 'Product not found' }, status: :not_found unless @product
  end

  def set_cart_service
    @cart_service = CartService.new(@cart)
  end

  def cart_params
    params.fetch(:cart, {}).permit(:product_id, :quantity)
  end  
end

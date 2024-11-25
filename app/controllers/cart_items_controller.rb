# class CartItemsController < ApplicationController
#   before_action :set_cart, only: %i[ create destroy ]
#   before_action :set_product, only: %i[ create ]
#   before_action :set_cart_item, only: %i[ destroy ]
#   before_action :set_cart_item_service

#   def create
    
#   end

#   private

#   def set_cart
#     @cart = Cart.find_by(id: params[:cart_id])
#   rescue ActiveRecord::RecordNotFound
#     render json: { error: 'Cart not found' }, status: :not_found
#   end

#   def set_product
#     @product = Product.find_by(id: params[:product_id])
#   rescue ActiveRecord::RecordNotFound
#     render json: { error: 'Product not found' }, status: :not_found
#   end

#   def set_cart_item
#     @cart_item = CartItem.find_by(id: params[:id])
#   rescue ActiveRecord::RecordNotFound
#     render json: { error: 'Cart item not found' }, status: :not_found
#   end

#   def set_cart_items_service
#     @cart_items_service = CartItemsService.new(@cart)
#   end

#   def cart_item_params
#     params.require(:cart_item).permit(:product_id, :quantity)
#   end
# end
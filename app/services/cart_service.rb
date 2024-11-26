class CartService
  class ProductNotFoundError < StandardError; end
  class UnableToSaveCartItemError < StandardError; end

  def initialize(cart)
    @cart = cart
  end

  def add_product(product, quantity)
    cart_item = @cart.items.find_or_initialize_by(product: product)
    update_cart_item(cart_item, quantity, product)
  end

  def add_item(product, quantity)
    cart_item = @cart.items.find_by(product: product)

    if cart_item
      update_cart_item(cart_item, quantity, product)
    else
      add_product(product, quantity)
    end
  end

  def remove_item(product)
    cart_item = @cart.items.find_by(product: product)

    if cart_item
      cart_item.destroy
      update_cart_total_price
      cart_item
    else
      raise ProductNotFoundError, "Product not found in the cart"
    end
  end
  
  def cart_payload
    {
      id: @cart.id,
      products: build_product_payload,
      total_price: @cart.total_price
    }
  end

  private

  def update_cart_item(cart_item, quantity, product)
    cart_item.quantity = cart_item.quantity.to_i + quantity
    cart_item.unit_price = product.price
    cart_item.total_price = calculate_total_price(cart_item)

    if cart_item.save
      update_cart_total_price
      cart_item
    else
      raise UnableToSaveCartItemError, "Unable to save cart item"
    end
  end

  def update_cart_total_price
    @cart.total_price = @cart.items.includes(:product).sum { |item| calculate_total_price(item) }
    @cart.save
  end

  def calculate_total_price(cart_item)
    cart_item.quantity * cart_item.product.price
  end

  def build_product_payload
    @cart.items.map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.price,
        total_price: calculate_total_price(item)
      }
    end
  end
end

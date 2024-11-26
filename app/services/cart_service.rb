class CartService
  def initialize(cart)
    @cart = cart
  end

  def add_product(product, quantity)
    cart_item = @cart.items.find_or_initialize_by(product: product)

    cart_item.quantity = cart_item.quantity.to_i + quantity
    cart_item.unit_price = product.price
    cart_item.total_price = cart_item.quantity * product.price
  
    if cart_item.save
      update_cart_total_price
  
      cart_item
    else
      nil
    end
  end

  def add_item(product, quantity)
    # if the product doesnt exists, should add_product, otherwise, should update the quantity and total_price
    
    cart_item = @cart.items.find_by(product: product)

    if cart_item
      cart_item.quantity = cart_item.quantity.to_i + quantity
      cart_item.total_price = cart_item.quantity * product.price
      cart_item.save

      update_cart_total_price

      cart_item
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
      # raise error as the product is not in the cart
      nil
    end
  end
  

  def cart_payload
    {
      id: @cart.id,
      products: @cart.items.map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.quantity * item.product.price
        }
      end,
      total_price: @cart.total_price
    }
  end

  private

  def update_cart_total_price
    @cart.total_price = @cart.items.includes(:product).sum do |item|
      item.quantity * item.product.price
    end
    @cart.save
  end

  def update_cart_item_total_price(cart_item)
    cart_item.total_price = cart_item.quantity * cart_item.product.price
    cart_item.save
  end
end

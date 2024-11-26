FactoryBot.define do
  factory :cart_item do
    cart
    product
    quantity { 1 }
    unit_price { product.price }
    total_price { quantity * unit_price }

    # Factory traits
    trait :with_product do
      product
    end

    trait :with_quantity do
      quantity { 2 }
    end
  end
end

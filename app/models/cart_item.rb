class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_prices

  private

  def calculate_prices
    self.unit_price ||= product.price if product
    self.total_price ||= unit_price.to_f * quantity.to_i
  end
end

class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  alias_method :items, :cart_items
  
  # sets default value for total_price
  after_initialize :set_default_total_price

  def set_default_total_price
    self.total_price = 0
  end

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
end

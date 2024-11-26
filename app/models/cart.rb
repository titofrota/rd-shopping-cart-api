class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  alias_method :items, :cart_items

  enum status: { active: 0, abandoned: 1 }

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :inactive_for_three_hours, -> { where('last_interacted_at < ?', 3.hours.ago) }
  
  scope :abandoned_for_seven_days, -> { 
    where('last_interacted_at < ?', 7.days.ago).where(status: :abandoned)
  }
  
  after_initialize :set_default_total_price

  def set_default_total_price
    self.total_price = 0
  end
end

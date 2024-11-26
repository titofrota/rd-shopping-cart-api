class CartCleanupJob < ApplicationJob
  queue_as :default

  def perform
    mark_carts_as_abandoned
    remove_abandoned_carts
  end

  private

  def mark_carts_as_abandoned
    Cart.inactive_for_three_hours.update_all(status: :abandoned)
  end

  def remove_abandoned_carts
    Cart.abandoned_for_seven_days.destroy_all
  end
end
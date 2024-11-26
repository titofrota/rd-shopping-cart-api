class CartCleanupJob < ApplicationJob
  queue_as :default

  def perform
    mark_carts_as_abandoned
    remove_abandoned_carts
  end

  private

  def mark_carts_as_abandoned
    Cart.inactive_for_three_hours.each(&:mark_as_abandoned)
  end

  def remove_abandoned_carts
    Cart.abandoned_for_seven_days.each(&:remove_if_abandoned)
  end
end
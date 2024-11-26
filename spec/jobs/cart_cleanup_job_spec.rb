require 'rails_helper'

RSpec.describe CartCleanupJob, type: :job do
  describe 'perform' do
    let!(:cart) { create(:cart, :inactive_for_three_hours) }

    it 'marks the cart as abandoned after 3 hours of inactivity' do
      expect { described_class.perform_now }.to change { cart.reload.status }.from('active').to('abandoned')
    end

    it 'does not mark the cart as abandoned if not inactive for 3 hours' do
      cart.update(last_interacted_at: 2.hours.ago)
      expect { described_class.perform_now }.not_to change { cart.reload.status }
    end

    it 'removes the cart if abandoned for more than 7 days' do
      cart.update(status: :abandoned, last_interacted_at: 8.days.ago)
      expect { described_class.perform_now }.to change { Cart.count }.by(-1)
    end

    it 'does not remove the cart if it has not been abandoned for more than 7 days' do
      cart.update(last_interacted_at: 3.days.ago, status: :active)
      expect { described_class.perform_now }.not_to change { Cart.count }
    end

    it 'does not mark as abandoned a cart that was already abandoned recently' do
      cart.update(status: :abandoned, last_interacted_at: 2.hours.ago)
      expect { described_class.perform_now }.not_to change { cart.reload.status }
    end

    it 'processes multiple carts correctly' do
      active_cart = create(:cart, :inactive_for_three_hours)
      abandoned_cart = create(:cart, :inactive_for_seven_days, :abandoned)
      
      expect { described_class.perform_now }.to change { active_cart.reload.status }.from('active').to('abandoned')
                                                        .and change { Cart.count }.by(-1)
    end

    it 'destroys carts that have been abandoned for more than 7 days' do
      cart.update(status: :abandoned, last_interacted_at: 8.days.ago)
      expect { described_class.perform_now }.to change { Cart.exists?(cart.id) }.from(true).to(false)
    end
  end
end

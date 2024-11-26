class AddLastInteractedAtToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :last_interacted_at, :datetime
  end
end

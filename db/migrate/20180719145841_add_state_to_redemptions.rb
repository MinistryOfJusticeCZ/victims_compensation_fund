class AddStateToRedemptions < ActiveRecord::Migration[5.2]
  def change
    add_column :redemptions, :state, :integer, default: 0, null: false, index: true
  end
end

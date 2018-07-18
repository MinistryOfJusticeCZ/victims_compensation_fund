class RemoveRedemptionIdFromBudgetItem < ActiveRecord::Migration[5.2]
  def change
    remove_column :state_budget_items, :redemption_id
    remove_column :state_budget_items, :value
  end
end

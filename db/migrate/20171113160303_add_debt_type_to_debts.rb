class AddDebtTypeToDebts < ActiveRecord::Migration[5.1]
  def change
    add_column :debts, :debt_type, :integer, default: 1
  end
end

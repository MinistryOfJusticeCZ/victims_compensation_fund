class AddDeletedAtToDebts < ActiveRecord::Migration[5.1]
  def change
    add_column :debts, :deleted_at, :datetime
    add_column :appeals, :deleted_at, :datetime
    add_column :claims, :deleted_at, :datetime
    add_index :debts, :deleted_at
    add_index :appeals, :deleted_at
    add_index :claims, :deleted_at
  end
end

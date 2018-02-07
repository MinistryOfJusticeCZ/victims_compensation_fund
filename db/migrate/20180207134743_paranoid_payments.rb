class ParanoidPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :satisfactions, :deleted_at, :datetime
    add_column :redemptions, :deleted_at, :datetime
    add_column :payments, :deleted_at, :datetime
    add_index :satisfactions, :deleted_at
    add_index :redemptions, :deleted_at
    add_index :payments, :deleted_at
  end
end

class CreateStateBudgetItems < ActiveRecord::Migration[5.2]
  def change
    create_table :state_budget_items do |t|
      t.references :debt, foreign_key: true
      t.references :redemption, foreign_key: true
      t.references :payment, foreign_key: true
      t.date :due_at
      t.decimal :value, precision: 12, scale: 5

      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end

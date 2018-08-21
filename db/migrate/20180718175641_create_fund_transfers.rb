class CreateFundTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :fund_transfers do |t|
      t.references :redemption, foreign_key: true
      t.references :state_budget_item, foreign_key: true
      t.references :satisfaction, foreign_key: true
      t.decimal :value, precision: 12, scale: 5

      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end

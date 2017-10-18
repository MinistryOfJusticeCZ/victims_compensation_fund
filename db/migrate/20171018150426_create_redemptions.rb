class CreateRedemptions < ActiveRecord::Migration[5.1]
  def change
    create_table :redemptions do |t|
      t.references :payment, foreign_key: true
      t.references :debt, foreign_key: true
      t.references :author, foreign_key: {to_table: :egov_utils_users}

      t.timestamps
    end
  end
end

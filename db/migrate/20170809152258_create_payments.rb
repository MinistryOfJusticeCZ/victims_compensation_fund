class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :status
      t.string :payment_uid
      t.decimal :value, precision: 15, scale: 3
      t.integer :direction
      t.integer :currency_code, limit: 4
      t.decimal :currency_value, precision: 15, scale: 3

      t.timestamps
    end
  end
end

class AddAmountToAppeal < ActiveRecord::Migration[5.1]
  def change
    add_column :appeals, :amount, :decimal, precision: 15, scale: 3
  end
end

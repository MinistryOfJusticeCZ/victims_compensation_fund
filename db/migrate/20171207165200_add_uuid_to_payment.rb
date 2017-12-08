class AddUuidToPayment < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :uuid, :string
  end
end

class AddStatusToClaim < ActiveRecord::Migration[5.1]
  def change
    add_column :claims, :status, :integer, default: 1
  end
end

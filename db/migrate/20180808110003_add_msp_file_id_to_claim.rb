class AddMspFileIdToClaim < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :msp_file_id, :string
  end
end

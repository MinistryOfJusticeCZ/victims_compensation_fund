class CreateSatisfactions < ActiveRecord::Migration[5.1]
  def change
    create_table :satisfactions do |t|
      t.references :payment, foreign_key: true
      t.references :appeal, foreign_key: true
      t.references :author, foreign_key: {to_table: :egov_utils_users}

      t.timestamps
    end
  end
end

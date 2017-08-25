class CreateAppeals < ActiveRecord::Migration[5.1]
  def change
    create_table :appeals do |t|
      t.references :claim, foreign_key: true
      t.references :victim, foreign_key: {to_table: :egov_utils_people}
      t.integer :status
      t.references :assigned_to, foreign_key: {to_table: :egov_utils_users}
      t.string :file_uid
      t.string :bank_account
      t.integer :payment_type
      t.string :bank_account

      t.timestamps
    end
  end
end

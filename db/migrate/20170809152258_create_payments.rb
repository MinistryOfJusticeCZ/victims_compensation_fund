class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :claim, foreign_key: true
      t.references :offender, foreign_key: {to_table: :egov_utils_people}
      t.references :author, foreign_key: {to_table: :egov_utils_users}
      t.integer :status
      t.string :payment_uid
      t.float :value

      t.timestamps
    end
  end
end

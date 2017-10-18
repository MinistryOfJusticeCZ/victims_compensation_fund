class CreateDebts < ActiveRecord::Migration[5.1]
  def change
    create_table :debts do |t|
      t.references :claim, foreign_key: true
      t.references :offender, foreign_key: {to_table: :egov_utils_people}
      t.decimal :value

      t.timestamps
    end
  end
end

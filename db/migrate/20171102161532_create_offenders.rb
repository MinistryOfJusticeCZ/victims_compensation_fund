class CreateOffenders < ActiveRecord::Migration[5.1]
  def change
    create_table :offenders do |t|
      t.references :person, foreign_key: {to_table: :egov_utils_people}
      t.references :claim, foreign_key: true

      t.timestamps
    end
  end
end

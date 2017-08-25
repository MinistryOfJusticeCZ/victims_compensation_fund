class CreateClaims < ActiveRecord::Migration[5.1]
  def change
    create_table :claims do |t|
      t.string :file_uid
      t.string :court_uid
      t.datetime :binding_effect

      t.timestamps
    end
  end
end

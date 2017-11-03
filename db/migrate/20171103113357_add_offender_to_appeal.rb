class AddOffenderToAppeal < ActiveRecord::Migration[5.1]
  def change
    add_reference :appeals, :offender, foreign_key: true
  end
end

class VictimsToNewPeople < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :appeals, column: :victim_id
    rows = ActiveRecord::Base.connection.select_rows(<<-SQL)
      SELECT appeals.id, np.person_id
      FROM appeals INNER JOIN egov_utils_natural_people np ON appeals.victim_id = np.id
    SQL
    rows.each do |row|
      ActiveRecord::Base.connection.execute("UPDATE appeals SET victim_id = #{row.second} WHERE id = #{row.first}")
    end
    add_foreign_key :appeals, :egov_utils_people, column: :victim_id
  end
end

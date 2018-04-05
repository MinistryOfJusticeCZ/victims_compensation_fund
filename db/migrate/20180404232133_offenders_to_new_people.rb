class OffendersToNewPeople < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :offenders, column: :person_id
    rows = ActiveRecord::Base.connection.select_rows(<<-SQL)
      SELECT offenders.id, np.person_id
      FROM offenders INNER JOIN egov_utils_natural_people np ON offenders.person_id = np.id
    SQL
    rows.each do |row|
      ActiveRecord::Base.connection.execute("UPDATE offenders SET person_id = #{row.second} WHERE id = #{row.first}")
    end
    add_foreign_key :offenders, :egov_utils_people, column: :person_id
  end
end

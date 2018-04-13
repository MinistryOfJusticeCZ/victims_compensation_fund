class MoveOffendersToTable < ActiveRecord::Migration[5.1]
  def up
    Debt.transaction do
      debt_ary = ActiveRecord::Base.connection.select_rows('SELECT id, claim_id, offender_id FROM debts')

      remove_reference :debts, :offender, foreign_key: {to_table: :egov_utils_people}
      add_reference :debts, :offender, foreign_key: true

      debt_ary.each do |debt_id, claim_id, offender_id|
        off = Offender.create(claim_id: claim_id, person_id: offender_id)
        ActiveRecord::Base.connection.execute("UPDATE debts SET offender_id = #{off.id} WHERE id = #{debt_id}")
      end
    end
  end

  def down
    Offender.transaction do
      offenders_ary = Offender.all.pluck(:id, :claim_id, :person_id)
      debts_by_off = Debt.all.pluck(:id, :offender_id).group_by(&:second)

      remove_reference :debts, :offender, foreign_key: true
      add_reference :debts, :offender, foreign_key: {to_table: :egov_utils_people}


      offenders_ary.each do |off_id, claim_id, person_id|
        Debt.where(id: debts_by_off[off_id].collect(&:first)).update_all(claim_id: claim_id, offender_id: person_id)
      end
    end
  end
end

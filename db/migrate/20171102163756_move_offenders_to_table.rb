class MoveOffendersToTable < ActiveRecord::Migration[5.1]
  def up
    Debt.transaction do
      debt_ary = Debt.all.pluck(:id, :claim_id, :offender_id)

      remove_reference :debts, :offender, foreign_key: {to_table: :egov_utils_people}
      add_reference :debts, :offender, foreign_key: true

      debt_ary.each do |debt_id, claim_id, offender_id|
        off = Offender.create(claim_id: claim_id, person_id: offender_id)
        Debt.where(id: debt_id).update_all(offender_id: off.id)
      end
    end
  end

  def down
    Offender.transaction do
      offenders_ary = Offender.all.pluck(:id, :claim_id, :person_id)
      debts_by_off = Debt.all.pluck(:id, :offender_id).group_by(&:first)

      remove_reference :debts, :offender, foreign_key: true
      add_reference :debts, :offender, foreign_key: {to_table: :egov_utils_people}


      offenders_ary.each do |off_id, claim_id, person_id|
        Debt.where(offender_id: debts_by_off[off_id].collect(&:second)).update_all(claim_id: claim_id, offender_id: offender_id)
      end
    end
  end
end

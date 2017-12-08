class Claim < ApplicationRecord


  has_many :appeals
  has_many :debts

  enum status: { empty: 1, appeal_only: 2, debt_only: 3, both: 4 }

  validates :court_uid, inclusion: { in: :court_uids }
  validates :file_uid, uniqueness: {scope: :court_uid}, fileuid: true

  serialize :file_uid, EgovUtils::Fileuid

  def court_uids
    user_org_keys = EgovUtils::User.current.organization_with_suborganizations_keys
    user_org_keys.present? ? user_org_keys : EgovUtils::Organization.courts.collect{|c| c.key}
  end


  def set_status
    status = 'both'
    if !appeals.any? && !debts.any?
      status = 'empty'
    elsif !debts.any?
      status = 'appeal_only'
    elsif !appeals.any?
      status = 'debt_only'
    end
    self.update_column(:status, status)
  end

end

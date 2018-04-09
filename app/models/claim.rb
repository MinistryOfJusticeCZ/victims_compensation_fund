class Claim < ApplicationRecord


  has_many :appeals
  has_many :debts

  enum status: { empty: 1, appeal_only: 2, debt_only: 3, both: 4 }

  validates :court_uid, inclusion: { in: :court_uids }
  validates :file_uid, uniqueness: {scope: :court_uid}, fileuid: true

  serialize :file_uid, EgovUtils::Fileuid::Coder.new(:file_uid, 'court')

  audited

  def court_uids
    CourtUidAttribute.new(self.class, 'court_uid').user_allowed_organizations.collect{|o| o.key}
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

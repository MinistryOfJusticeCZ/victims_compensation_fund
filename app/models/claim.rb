class Claim < ApplicationRecord

  has_many :appeals, dependent: :destroy
  has_many :debts, dependent: :destroy
  belongs_to :assigned_to, class_name: 'EgovUtils::User'

  enum status: { empty: 1, appeal_only: 2, debt_only: 3, both: 4 }

  validates :court_uid, inclusion: { in: :court_uids }
  validates :file_uid, uniqueness: {scope: :court_uid}, fileuid: true

  serialize :file_uid, EgovUtils::Fileuid::Coder.new(:file_uid, 'court')

  acts_as_paranoid
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

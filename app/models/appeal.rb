class Appeal < ApplicationRecord

  belongs_to :claim
  belongs_to :victim, class_name: 'Victim'
  belongs_to :offender
  belongs_to :assigned_to, class_name: 'EgovUtils::User', optional: true
  has_many :satisfactions

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :victim, :offender

  enum payment_type: { account: 1, foldout: 2 }

  validates :amount, numericality: true, allow_nil: true

  before_validation :set_offenders_claim, if: :new_record?
  after_save :set_claim_status


  private

    def set_offenders_claim
      offender.claim ||= claim if offender && claim
    end

    def set_claim_status
      claim.set_status
    end
end

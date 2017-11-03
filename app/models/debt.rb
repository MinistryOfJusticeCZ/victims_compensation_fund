class Debt < ApplicationRecord
  belongs_to :claim
  belongs_to :offender

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :offender

  validates :value, numericality: true, allow_nil: true

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

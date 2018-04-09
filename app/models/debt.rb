class Debt < ApplicationRecord
  belongs_to :claim
  belongs_to :offender

  has_many :redemptions

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :offender

  enum debt_type: { financial: 1, forfeiture_possession: 2, forfeiture_thing: 3, forfeiture_substitute: 4, confiscation_substitute: 5, confiscation_thing: 6, confiscation_possession: 7 }

  with_options if: :financial? do |financial_debt|
    financial_debt.validates :value, numericality: true
  end

  with_options unless: :financial? do |nonfinancial_debt|
    nonfinancial_debt.validates :value, numericality: true, allow_nil: true
  end

  audited

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

class Appeal < ApplicationRecord

  belongs_to :claim
  belongs_to :victim, class_name: 'Victim'
  belongs_to :offender
  belongs_to :assigned_to, class_name: 'EgovUtils::User', optional: true
  has_many :satisfactions, dependent: :destroy

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :victim, :offender

  # scope :unsatisfied, ->{
  #   left_outer_joins(satisfactions: :payment).where(
  #     arel_table[:amount].gt(
  #       Arel::Nodes::Addition.new(
  #         Payment.arel_table[:value].sum,
  #         Arel::Nodes::SqlLiteral.new('0.0001')
  #       )
  #     )
  #   )
  # }

  enum payment_type: { account: 1, foldout: 2 }

  validates :amount, numericality: true, allow_nil: true

  acts_as_paranoid
  audited

  before_validation :set_offenders_claim
  after_save :set_claim_status

  def claim_may_deleted
    Claim.with_deleted.find_by(id: claim_id)
  end

  def currency_code
    'czk'
  end

  def satisfied?
    unsatisfied_amount < 0.0001
  end

  def unsatisfied_amount
    return if amount.nil?
    @unsatisfied_amount ||= amount - satisfactions.joins(:payment).sum(Payment.arel_table[:value])
  end


  private

    def set_offenders_claim
      offender.claim ||= claim if offender && claim
    end

    def set_claim_status
      claim.set_status
    end
end

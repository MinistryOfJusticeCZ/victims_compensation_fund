class Payment < ApplicationRecord

  has_one :satisfaction
  has_one :redemption
  has_one :state_budget_item
  has_one :satisfaction_may_deleted, ->{with_deleted}, class_name: 'Satisfaction'
  has_one :redemption_may_deleted, ->{with_deleted}, class_name: 'Redemption'
  has_one :budget_item_may_deleted, ->{with_deleted}, class_name: 'StateBudgetItem'

  enum currency_code: { czk: 1, eur: 2, usd: 3 }
  enum direction: { incoming: 1, outgoing: 16 }
  # sent to ires, received by ires, accepted by ires user, processed payment(sent or received payment)
  enum status: { sent: 1, received: 2, accepted: 3, processed: 10, canceled: 20, updated: 30 }

  validates :value, numericality: true, if: :in_czk? # and status is not paid, if paid, it should be filled.
  validates :currency_value, numericality: true, unless: :in_czk?

  audited
  acts_as_paranoid

  before_validation :set_default_currency
  before_validation :set_currency_value, if: :value_changed?
  after_create   :generate_uid
  after_create   :send_to_ires, if: :direction?
  before_update  :mark_for_ires_update, if: :value_changed?
  after_update   :send_to_ires, if: :value_changed?
  after_destroy  :send_to_ires, if: :direction?

  scope :for_organization, ->(organization_code) {
    s = PaymentSchema.new
    s.available_attributes << AzaharaSchema::DerivedAttribute.new(Payment, 'derived_court_uid', :concat, 'satisfaction-appeal-claim-court_uid', 'redemption-debt-claim-court_uid', schema: s)
    s.add_filter('derived_court_uid', '~', organization_code)
    s.instance_variable_set(:@entity_scope, self)
    s.filtered_scope
  }

  def value
    super || currency_value
  end

  def paid_record
    case direction
    when 'outgoing'
      budget_item_may_deleted || satisfaction_may_deleted
    when 'incoming'
      redemption_may_deleted
    end
  end

  def summary_record
    case direction
    when 'outgoing'
      budget_item_may_deleted && budget_item_may_deleted.debt || satisfaction_may_deleted.appeal
    when 'incoming'
      redemption_may_deleted.debt
    end
  end

  def file_uid
    paid_record.file_uid
  end

  def claim
    summary_record.claim
  end

  def person
    case direction
    when 'outgoing'
      satisfaction_may_deleted && satisfaction_may_deleted.appeal.victim
    when 'incoming'
      redemption_may_deleted.debt.offender.person
    end
  end

    def budget_category_prefix
      case direction
      when 'incoming'
        88
      when 'outgoing'
        80
      end
    end

  private

    def set_default_currency
      self.currency_code ||= 'czk'
    end

    def in_czk?
      currency_code.to_s == 'czk'
    end

    def first_id_in_year
      Rails.cache.fetch("payment/#{Date.today.year}/first_id") do
        Payment.unscoped.where(Payment.arel_table[:created_at].gteq( Date.new(Date.today.year, 1, 1) )).order(:created_at).select(:id).first.try(:id).to_i
      end
    end

    def set_currency_value
      if !in_czk?
        self.currency_value = self.value
        self.value = nil
      end
    end

    def generate_uid
      self.update_columns(payment_uid: "#{budget_category_prefix}#{(id-first_id_in_year+1).to_s.rjust(6, "0")}#{Time.now.strftime("%y")}")
    end

    def mark_for_ires_update
      self.status = 'updated'
    end

    def send_to_ires
      return unless direction == 'incoming'
      SendPaymentJob.perform_later(id)
    end

end

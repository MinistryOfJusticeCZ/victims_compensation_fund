class Payment < ApplicationRecord

  has_one :satisfaction
  has_one :redemption

  enum currency_code: { czk: 1, eur: 2, usd: 3 }
  enum direction: { incoming: 1, outgoing: 16 }

  validates :value, numericality: true, if: :in_czk? # and status is not paid, if paid, it should be filled.
  validates :currency_value, numericality: true, unless: :in_czk?

  before_validation :set_default_currency
  before_validation :set_currency_value, if: :value_changed?
  after_create :generate_uid, :send_to_ires

  scope :for_organization, ->(organization_code) {
    s = PaymentSchema.new
    s.available_attributes << AzaharaSchema::DerivedAttribute.new(Payment, 'derived_court_uid', :concat, 'satisfaction-appeal-claim-court_uid', 'redemption-debt-claim-court_uid', schema: s)
    s.add_filter('derived_court_uid', '~', organization_code)
    s.instance_variable_set(:@entity_scope, self)
    s.filtered_scope
  }

  def file_uid
    case direction
    when 'outgoing'
      satisfaction.file_uid
    when 'incoming'
      redemption.file_uid
    end
  end

  def claim
    case direction
    when 'outgoing'
      satisfaction.appeal.claim
    when 'incoming'
      redemption.debt.claim
    end
  end

  def person
    case direction
    when 'outgoing'
      satisfaction.appeal.victim
    when 'incoming'
      redemption.debt.offender.person
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
        Payment.where(Payment.arel_table[:created_at].gteq( Date.new(Date.today.year, 1, 1) )).order(:created_at).select(:id).first.try(:id).to_i
      end
    end

    def set_currency_value
      if !in_czk?
        self.currency_value = self.value
        self.value = nil
      end
    end

    def generate_uid
      self.update_columns(payment_uid: "88#{(id-first_id_in_year+1).to_s.rjust(6, "0")}#{Time.now.strftime("%y")}")
    end

    def send_to_ires
      SendPaymentJob.perform_later(claim.court_uid)
    end

end

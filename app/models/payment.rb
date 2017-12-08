class Payment < ApplicationRecord

  has_one :satisfaction
  has_one :redemption

  enum currency_code: { czk: 1, eur: 2, usd: 3 }
  enum direction: { incoming: 1, outgoing: 16 }

  validates :value, numericality: true, if: :in_czk? # and status is not paid, if paid, it should be filled.
  validates :currency_value, numericality: true, unless: :in_czk?

  before_validation :set_default_currency
  before_validation :set_currency_value, if: :value_changed?
  after_create :generate_uid

  def file_uid
    case direction
    when 'outgoing'
      satisfaction.file_uid
    when 'incoming'
      redemption.file_uid
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
      self.update_columns(payment_uid: "88#{(id-first_id_in_year+1).to_s.rjust(6, "0")}#{Time.now.strftime("%y")}", uuid: SecureRandom.uuid)
    end

end

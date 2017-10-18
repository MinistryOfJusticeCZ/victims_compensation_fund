class Payment < ApplicationRecord

  has_many :satisfactions
  has_many :redemptions

  enum currency_code: { czk: 1, eur: 2, usd: 3 }

  validates :value, numericality: true

  before_validation :calculate_value, if: :value_recalculation_needed?
  after_create :generate_uid


  private

    def first_id_in_year
      Rails.cache.fetch("payment/#{Date.today.year}/first_id") do
        Payment.where(Payment.arel_table[:created_at].gteq( Date.new(Date.today.year, 1, 1) )).order(:created_at).select(:id).first.try(:id).to_i
      end
    end

    def calculate_value
      self.currency_value = self.value
      if currency_code.to_s != 'czk'
        self.value = self.currency_value * 25.2
      end
    end

    def value_recalculation_needed?
      value_changed?
    end

    def generate_uid
      self.update_column(:payment_uid, "#{Time.now.strftime("%y")}#{(id-first_id_in_year+1).to_s.rjust(8, "0")}")
    end

end

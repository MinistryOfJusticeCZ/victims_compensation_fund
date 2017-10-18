class Payment < ApplicationRecord

  has_many :satisfactions
  has_many :redemptions

  enum currency_code: { czk: 1, eur: 2, usd: 3 }

  validates :value, numericality: true

  before_validation :calculate_value, if: :value_recalculation_needed?
  after_create :generate_uid


  private

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
      self.update_column(:payment_uid, "#{Time.now.strftime("%y")}#{id.to_s.rjust(8, "0")}")
    end

end

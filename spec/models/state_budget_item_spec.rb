require 'rails_helper'

RSpec.describe StateBudgetItem, type: :model do
  describe '#create' do
    let(:redemption) { FactoryBot.create(:redemption) }

    subject { StateBudgetItem.create(
      debt_id: redemption.debt_id,
      fund_transfers_attributes: { '0' => {redemption_id: redemption.id} }
    )}

    it 'set payment value' do
      expect(subject).to be_persisted
      expect(subject.payment).to be_a(Payment)

      redemption_value = redemption.payment.value
      budget_val = redemption_value - ((redemption_value * 2) / 100).ceil
      expect(subject.payment.value).to eq(budget_val)
    end
  end
end

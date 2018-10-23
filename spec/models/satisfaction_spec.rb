require 'rails_helper'

RSpec.describe Satisfaction, type: :model do
  describe '#create' do
    let(:redemption_value){ 500.0 }
    let(:appeal) { FactoryBot.create(:appeal, amount: 1000.0) }

    subject { Satisfaction.create(
      appeal_id: appeal.id,
      author_id: FactoryBot.create(:egov_utils_user).id,
      fund_transfers_attributes: [
        {redemption_id: FactoryBot.create(:redemption, payment_value: redemption_value).id},
        {redemption_id: FactoryBot.create(:redemption, payment_value: redemption_value).id}
      ]
    )}

    it 'set payment value' do
      expect(subject).to be_persisted
      expect(subject.payment).to be_a(Payment)

      expect(subject.payment.value).to eq(redemption_value * 2)
    end

    context 'with redemption value too high' do
      let(:redemption_value){ 2000.0 }

      it 'satisfy to the maximum of appeal amount' do
        expect(subject.fund_transfers.first.value).to eq(1000.0)
        expect(subject.payment.value).to eq(1000.0)
      end
    end
  end
end

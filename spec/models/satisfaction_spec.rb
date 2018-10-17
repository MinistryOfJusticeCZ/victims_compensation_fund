require 'rails_helper'

RSpec.describe Satisfaction, type: :model do
  describe '#create' do
    let(:redemption) { FactoryBot.create(:redemption) }

    subject { Satisfaction.create(
      appeal_id: FactoryBot.create(:appeal).id,
      author_id: FactoryBot.create(:egov_utils_user).id,
      fund_transfers_attributes: { '0' => {redemption_id: redemption.id} }
    )}

    it 'set payment value' do
      expect(subject).to be_persisted
      expect(subject.payment).to be_a(Payment)

      redemption_value = redemption.payment.value
      expect(subject.payment.value).to eq(redemption_value)
    end
  end
end

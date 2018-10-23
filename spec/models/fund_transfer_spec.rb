require 'rails_helper'

RSpec.describe FundTransfer, type: :model do
  describe '#create' do
    let(:redemption) { FactoryBot.create(:redemption, payment_value: 10000.0) }
    let(:transfer1) { FactoryBot.create(:fund_transfer, redemption: redemption, value: 5000.0) }

    it 'dont allow transfers over redemption value' do
      transfer1; redemption.reload
      expect { FundTransfer.create(redemption: redemption) }.to_not change(FundTransfer, :count)
    end

  end
end

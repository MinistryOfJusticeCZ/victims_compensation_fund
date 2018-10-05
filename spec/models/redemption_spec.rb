require 'rails_helper'

RSpec.describe Redemption, type: :model do
  describe '#update' do
    let(:redemption){ FactoryBot.create(:redemption) }

    describe 'updating transfered money records' do
      let(:fundtransfer_double){ instance_double('FundTransfer') }
      let(:state_budget_item_double){ instance_double('StateBudgetItem') }

      before(:each) do
        ftr_scope = double('fund_transfers scope')
        allow(fundtransfer_double).to receive('transfered_to').and_return(state_budget_item_double)
        allow(ftr_scope).to receive('exists?').and_return(true)
        allow(ftr_scope).to receive('size').and_return(1)
        allow(ftr_scope).to receive('first').and_return(fundtransfer_double)
        allow(redemption).to receive('fund_transfers').and_return(ftr_scope)
      end

      it 'calls set_payment_value' do
        # should be called once, but redemption is updated twice by the definition of payment - redemption
        expect(state_budget_item_double).to receive(:set_payment_value).at_least(:once)
        redemption.update(payment_attributes: { value: 300 })
      end

    end
  end
end

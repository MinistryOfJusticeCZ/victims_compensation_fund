require 'rails_helper'

RSpec.describe SatisfactionsHelper, type: :helper do

  let(:redemption){ double(Redemption, id: 2, payment: double(value: 200)) }
  let(:appeal){ double(Appeal, id: 1) }

  describe "#satisfaction_transfer_redemption_path" do
    it "gets redemption value if appeal value is nil" do
      allow(appeal).to receive('unsatisfied_amount').and_return(nil)

      expect(helper).to receive(:satisfactions_path).with(satisfaction: {appeal_id: appeal.id, fund_transfers_attributes: {'0' => {redemption_id: redemption.id, value: 200}}})
      helper.satisfaction_transfer_redemption_path(appeal, redemption)
    end
  end

end

require 'rails_helper'

RSpec.describe SatisfactionsHelper, type: :helper do

  let(:redemption){ double(Redemption, id: 2, payment: double(value: 200)) }
  let(:appeal){ double(Appeal, id: 1, victim: double(fullname: 'Poskozeny')) }

  describe '#buton_to_satisfaction_transfer_redemption' do
    it 'transfers maximaly appeal value' do
      allow(appeal).to receive('unsatisfied_amount').and_return(10)

      expect(helper).to receive(:t)
                          .with('label_transfer_amount_to_victim', victim: 'Poskozeny', amount: 10)
                          .and_return('Zaplatit 10 Poskozeny')
      expect(helper).to receive('satisfaction_transfer_redemption_path')
                          .with(appeal, redemption, 10)
                          .and_return('/path/to/transfer/10/to/1')
      expect(helper).to receive(:button_to).with('Zaplatit 10 Poskozeny', '/path/to/transfer/10/to/1', have_key(:class))
      helper.buton_to_satisfaction_transfer_redemption(appeal, redemption)
    end
  end

  describe "#satisfaction_transfer_redemption_path" do
    it "gets redemption value if appeal value is nil" do
      allow(appeal).to receive('unsatisfied_amount').and_return(nil)

      expect(helper).to receive(:satisfactions_path).with(satisfaction: {appeal_id: appeal.id, fund_transfers_attributes: {'0' => {redemption_id: redemption.id, value: 200}}})
      helper.satisfaction_transfer_redemption_path(appeal, redemption)
    end
  end

end

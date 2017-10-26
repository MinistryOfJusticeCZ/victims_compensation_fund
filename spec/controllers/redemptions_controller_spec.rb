require 'rails_helper'

RSpec.describe RedemptionsController, type: :controller do
  describe '#create', logged: :admin do
    let(:redemption_params) {
      {
        payment_attributes: { value: 100, currency_code: 'czk'},
        debt_attributes: {
          value: '150',
          claim_attributes: { court_uid: 'OSSCECV', file_uid: 'ten-hajzl-je-moc-dobrej'},
          offender_attributes: {firstname: 'Adam', lastname: 'Ondra', birth_date: '5.2.1993'}
        }
      }
    }

    subject { post :create, params: { redemption: redemption_params } }

    it 'saves the record and sets all parameters' do
      expect { subject }.to change{ Redemption.count }.from(0).to(1)
      expect(subject).to redirect_to("/claims/#{Redemption.first.claim.id}")
    end
    it 'sets payment direction to incoming' do
      subject
      expect(Redemption.first.payment.direction).to eq('incoming')
    end
  end
end

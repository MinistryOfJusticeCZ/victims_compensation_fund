require 'rails_helper'

RSpec.describe RedemptionsController, type: :controller do
  describe '#create' do
    let(:redemption_params) {
      {
        payment_attributes: { value: 100, currency_code: 'czk'},
        debt_attributes: {
          value: '150',
          claim_attributes: { court_uid: '205030', file_uid: '200-T-20155/2017'},
          offender_attributes: {
            person_attributes: {
              person_type: 'natural',
              natural_person_attributes: {firstname: 'Adam', lastname: 'Ondra', birth_date: '5.2.1993'},
              residence_attributes: {street: 'Vysoka', house_number: '156', orientation_number: '9c', city: 'Neznamo', postcode: 42000, district: 'Hlavní město Praha'}
            }
          }
        }
      }
    }

    context 'as court user', logged: :court do
      subject { post :create, params: { redemption: redemption_params } }

      it 'saves the record and sets all parameters' do
        expect { subject }.to change{ Redemption.count }.from(0).to(1)
        expect(subject).to redirect_to("/debts/#{Redemption.first.debt.id}")
      end
      it 'sets payment direction to incoming' do
        subject
        expect(Redemption.first.claim.file_uid).to be_a(EgovUtils::Fileuid)
        expect(Redemption.first.claim.file_uid.to_s).to eq('200-T-20155/2017')
        expect(Redemption.first.payment.direction).to eq('incoming')
      end
    end
  end
end

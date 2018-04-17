require 'rails_helper'

RSpec.describe AppealsController, type: :controller do
  describe '#create' do
    let(:appeal_params) {
      {
        payment_type: 'account',
        file_uid: 'MSP-60/2018-ODSK-VTS',
        amount: 4500.5,
        claim_attributes: { court_uid: '205030', file_uid: '200-T-20155/2017'},
        victim_attributes: {
          person_type: 'natural',
          natural_person_attributes: {firstname: 'Adam', lastname: 'Ondra', birth_date: '5.2.1993'},
          residence_attributes: {street: 'Vysoka', house_number: '156', orientation_number: '9c', city: 'Neznamo', postcode: 42000, district: 'Hlavní město Praha'}
        },
        offender_attributes: {
          person_attributes: {
            person_type: 'natural',
            natural_person_attributes: {firstname: 'Zuzana', lastname: 'Adamcova', birth_date: '5.5.1985'},
            residence_attributes: {street: 'Vysoka', house_number: '156', orientation_number: '6a', city: 'Palermo', postcode: 42000, district: 'Hlavní město Praha'}
          }
        }
      }
    }

    context 'as compensator user', logged: :compensator do
      subject { post :create, params: { appeal: appeal_params } }

      it 'saves the record and sets all parameters' do
        expect { subject }.to change{ Appeal.count }.from(0).to(1)
        expect(subject).to redirect_to("/claims/#{Appeal.first.claim.id}")
      end
    end
  end
end

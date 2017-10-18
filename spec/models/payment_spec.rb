require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe '#calculate_value' do
    context 'with czk' do
      it 'sets currency value but does not change value' do
        payment = FactoryGirl.create(:payment, value: 100, currency_code: 'czk')
        expect( payment.value ).to eq(100)
        expect( payment.currency_value ).to eq(100)
      end
    end
    context 'with eur' do
      it 'sets currency_value and change value' do
        payment = FactoryGirl.create(:payment, value: 100, currency_code: 'eur')
        expect( payment.value ).not_to eq(100)
        expect( payment.currency_value ).to eq(100)
      end
    end
  end
end

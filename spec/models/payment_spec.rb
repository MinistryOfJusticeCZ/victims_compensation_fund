require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe '#set_currency_value' do
    context 'with czk' do
      it 'dont set currency value' do
        payment = FactoryBot.create(:payment, value: 100, currency_code: 'czk')
        expect( payment.value ).to eq(100)
        expect( payment.currency_value ).to be_nil
      end
    end
    context 'with eur' do
      it 'sets currency_value and unset the value' do
        payment = FactoryBot.create(:payment, value: 100, currency_code: 'eur')
        expect( payment.read_attribute(:value) ).to be_nil
        expect( payment.currency_value ).to eq(100)
        expect( payment.value ).to eq(100)
      end
    end
  end
end

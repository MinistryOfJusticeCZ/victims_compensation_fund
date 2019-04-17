require 'rails_helper'

RSpec.describe FundTransfer, type: :model do
  describe '#create' do
    let(:redemption) { FactoryBot.create(:redemption, payment_value: 10000.0) }
    let(:transfer1) { FactoryBot.create(:fund_transfer, redemption: redemption, value: 5000.0) }

    it 'allows exact amount even == is not working and nullify the value' do
      r = FactoryBot.create(:redemption, payment_value: 9871.79)
      ft = FundTransfer.new(redemption: r, value: '9871.79')
      expect { ft.save }.to change(FundTransfer, :count).by(1)
      expect(ft.read_attribute(:value)).to eq(nil)
    end

    it 'dont allow transfers over redemption value' do
      transfer1; redemption.reload
      expect { FundTransfer.create(redemption: redemption) }.to_not change(FundTransfer, :count)
    end

  end

  describe '#probation_value' do
    subject{ FundTransfer.new }

    it 'gives 2 percent of payment value' do
      allow(subject).to receive(:value).and_return(100.0)
      expect(subject.probation_value).to eq(2.0)
      expect(subject.budget_value).to eq(98.0)
    end
    it 'gives all value if its under 1 kronen' do
      allow(subject).to receive(:value).and_return(0.13)
      expect(subject.probation_value).to eq(0.13)
      expect(subject.budget_value).to eq(0.0)
    end

    it 'gives 1 kronen if it is bit over 1 kronen' do
      allow(subject).to receive(:value).and_return(1.13)
      expect(subject.probation_value).to eq(1.0)
      expect(subject.budget_value.round(2)).to eq(0.13)
    end
  end
end

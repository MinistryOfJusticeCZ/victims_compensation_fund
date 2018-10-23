require 'rails_helper'

RSpec.describe Debt, type: :model do
  describe '#unsatisfied_appeals' do
    subject{ Debt.new }
    let(:satisfied_appeal)   {
      a = instance_double('Appeal')
      allow(a).to receive('satisfied?').and_return(true)
      a
    }
    let(:unsatisfied_appeal) {
      a = instance_double('Appeal')
      allow(a).to receive('satisfied?').and_return(false)
      a
    }

    it 'returns unsatisfied_appeals' do
      appeals_double = double('appeal_scope')
      expect(subject).to receive('appeals').and_return(appeals_double)
      expect(appeals_double).to receive('to_a').and_return([satisfied_appeal, unsatisfied_appeal])
      expect(subject.unsatisfied_appeals).to contain_exactly(unsatisfied_appeal)
    end
  end
end

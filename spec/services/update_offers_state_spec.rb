require 'rails_helper'

RSpec.describe UpdateOffersState, type: :service do
  subject { UpdateOffersState.new }

  describe '#attributes' do
    it { is_expected.to respond_to(:status) }
  end

  context 'successful' do
    context 'with offers to update' do
      # explicit tomorrow DateTime so it creates with disabled state (bypassing model's hook)
      let!(:offers_list) { create_list(:offer, 4, state: :disabled, starts_at: DateTime.tomorrow) }

      before do
        Offer.update_all(starts_at: DateTime.yesterday)
        subject.call
      end

      it { expect(subject.status).to eq true }
      it { expect(Offer.where(state: :enabled).count).to eq 4 }
    end

    context 'with no offers to update' do
      # here explicit tomorrow DateTime is supplied to infer that no existent offers should be updated (not bypassing model's hook)
      let!(:offers_list) { create_list(:offer, 4, state: :disabled, starts_at: DateTime.tomorrow) }

      before { subject.call }

      it { expect(subject.status).to eq true }
      it { expect(Offer.where(state: :enabled).count).to eq 0 }
    end
  end

  context 'unsuccessful' do
    before { allow_any_instance_of(UpdateOffersState).to receive(:call).and_return(false) }

    it { expect(subject.call).to eq false }
  end
end

require 'rails_helper'

RSpec.describe Offer, type: :model do
  subject { build(:offer) }

  describe '#attributes' do
    it { is_expected.to respond_to(:advertiser_name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:starts_at) }
    it { is_expected.to respond_to(:ends_at) }
    it { is_expected.to respond_to(:premium) }
    it { is_expected.to respond_to(:admin_state_override) }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of(:advertiser_name) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:starts_at) }

    it { is_expected.to validate_uniqueness_of(:advertiser_name) }

    it { is_expected.to validate_length_of(:description).is_at_most(500) }

    context 'URI formats' do
      it { is_expected.to allow_value('https://example.com/?with_query_params=this&another=that').for(:url) }
      it { is_expected.not_to allow_value('htp:/this.is.a.bad.uri,com').for(:url) }
    end

    describe 'custom validations' do
      let(:offer) { build(:offer, starts_at: DateTime.now, ends_at: DateTime.now + 1) }

      it 'is valid when end date is posterior to start date' do
        expect(offer).to be_valid
      end

      it 'is invalid when end date is prior to start date' do
        offer.ends_at = offer.starts_at - 1

        expect(offer).not_to be_valid
      end
    end
  end

  describe '#scopes' do
    describe '#enabled' do
      let!(:enabled_offer) { create(:offer, starts_at: DateTime.yesterday, ends_at: DateTime.tomorrow) }
      let!(:unending_offer) { create(:offer, starts_at: DateTime.yesterday, ends_at: nil) }
      let!(:disabled_offer) { create(:offer, starts_at: DateTime.yesterday, ends_at: DateTime.yesterday + 1) }
      let!(:admin_disabled_offer) { create(:offer, starts_at: DateTime.yesterday, admin_state_override: true) }

      it { expect(Offer.enabled).to match_array [enabled_offer, unending_offer] }
    end
  end
end

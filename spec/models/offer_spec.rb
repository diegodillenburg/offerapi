require 'rails_helper'

RSpec.describe Offer, type: :model do
  subject { build(:offer) }

  describe '#attributes' do
    it { is_expected.to respond_to(:advertiser_name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:starts_at) }
    it { is_expected.to respond_to(:ends_at) }
    it { is_expected.to respond_to(:premium) }
    it { is_expected.to define_enum_for(:state).with(%i[disabled enabled]) }
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
      let(:offer) { build(:offer, starts_at: DateTime.now, ends_at: DateTime.now + 3.hours) }

      it 'is valid when end date is posterior to start date' do
        expect(offer).to be_valid
      end

      it 'is invalid when end date is prior to start date' do
        offer.ends_at = offer.starts_at - 1.hour

        expect(offer).not_to be_valid
      end
    end
  end

  describe '#methods' do
    context '#check_state' do
      let(:offer) { build(:offer) }

      it 'sets state to disable upon creation if start date hasn\'t been reached yet' do
        offer.starts_at = DateTime.now + 1.day

        offer.save
        offer.reload

        expect(offer.state).to eq 'disabled'
      end

      it 'sets state to enabled upon creation if start date has already been reached' do
        offer.starts_at = DateTime.now

        offer.save
        offer.reload

        expect(offer.state).to eq 'enabled'
      end
    end
  end
end

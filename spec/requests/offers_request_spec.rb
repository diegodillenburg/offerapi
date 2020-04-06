require 'rails_helper'

RSpec.describe "Offers", type: :request do
  subject { JSON.parse(response.body) }

  describe 'GET /offers' do
    let!(:enabled_offer) { create(:offer, starts_at: DateTime.yesterday) }
    let!(:unending_offer) { create(:offer, starts_at: DateTime.yesterday, ends_at: nil) }
    let!(:disabled_offer) { create(:offer, starts_at: DateTime.tomorrow) }
    let!(:admin_overriden_offer) { create(:offer, starts_at: DateTime.yesterday, admin_state_override: true) }

    subject { JSON.parse(response.body) }

    context 'with admin param' do
      before { get offers_path, params: { admin: true } }

      it { expect(response).to have_http_status 200 }
      it { expect(JSON.parse(response.body)['offers'].count).to eq 4 }
    end

    context 'without admin param' do
      before { get offers_path }

      it { expect(response).to have_http_status 200 }
      it { expect(subject['offers'].count).to eq 2}
    end
  end

  describe 'POST /offers' do

    context 'when successful' do
      let(:offer_params) { attributes_for(:offer) }

      before { post offers_path, params: { offer: offer_params } }

      it { expect(response).to have_http_status 201 }
      it { expect(Offer.count).to eq 1 }
      it { expect(subject['message']).to eq 'created' }
    end

    context 'when unsuccessful' do
      let(:invalid_offer_params) { attributes_for(:offer, starts_at: nil) }

      before { post offers_path, params: { offer: invalid_offer_params } }

      it { expect(response).to have_http_status 400 }
      it { expect(Offer.count).to eq 0 }
      it { expect(subject['message']).to eq 'error' }
    end
  end

  describe 'PUT /offers/:id' do
    let!(:offer) { create(:offer, ends_at: nil) }
    let(:new_date) { DateTime.tomorrow }

    context 'when successful' do
      before { put offer_path(offer.id), params: { offer: { ends_at: new_date } } }

      it { expect(response).to have_http_status 200 }
      it { expect(Offer.find(offer.id).ends_at).to eq new_date }
      it { expect(subject['message']).to eq 'updated' }
    end

    context 'when unsuccesful' do
      before { put offer_path(offer.id), params: { offer: { starts_at: nil } } }

      it { expect(response).to  have_http_status 400 }
      it { expect(Offer.find(offer.id).starts_at).not_to be_nil }
      it { expect(subject['message']).to eq 'error' }
    end
  end

  describe 'DELETE /offers/:id' do
    let!(:offer) { create(:offer) }

    before { delete offer_path(offer.id) }

    context 'when successful' do
      it { expect(response).to have_http_status 200 }
      it { expect(Offer.count).to eq 0 }
      it { expect(subject['message']).to eq 'deleted' }
    end

    # context 'when unsuccessful' do
    #   before { allow(offer).to receive(:delete).and_return(false) }

    #   it { expect(response).to have_http_status 400 }
    # end
  end

  describe 'PUT /offers/:id/override_state' do
    before { put override_state_offer_path(offer.id) }

    context 'when successful' do
      context 'when offer isn\'t yet overriden by admin' do
        let!(:offer) { create(:offer, admin_state_override: false) }

        it { expect(response).to have_http_status 200 }
        it { expect(offer.reload.admin_state_override).to eq true }
        it { expect(subject['message']).to eq 'overriden' }
      end
      context 'when offer is already overriden by admin' do
        let!(:offer) { create(:offer, admin_state_override: true) }

        it { expect(response).to have_http_status 200 }
        it { expect(offer.reload.admin_state_override).to eq false }
        it { expect(subject['message']).to eq 'overriden' }
      end
    end

    context 'when unsuccessful' do
    end
  end
end

class OffersController < ApplicationController
  expose :offers, -> { params[:admin] ? Offer.all : Offer.enabled }
  expose :offer

  def index
    render json: { offers: offers }, status: 200
  end

  def create
    if offer.save
      render json: { message: :created }, status: 201
    else
      render json: { message: :error }, status: 400
    end
  end

  def update
    if offer.update(offer_params)
      render json: { message: :updated }, status: 200
    else
      render json: { message: :error }, status: 400
    end
  end

  def destroy
    if offer.delete
      render json: { message: :deleted }, status: 200
    else
      render json: { message: :error }, status: 400
    end
  end

  def override_state
    # override_state toggles the admin_state_override attribute denoting wether an admin has force-disabled an offer or not
    # when set to true offer is treated as disabled regardless of its start and end dates
    if offer.update(admin_state_override: !offer.admin_state_override)
      render json: { message: :overriden, admin_state_override: offer.admin_state_override }, status: 200
    else
      render json: { message: :error }, status: 400
    end
  end

  private

  def offer_params
    params.require(:offer).permit(:advertiser_name, :url, :description, :starts_at, :ends_at, :premium, :admin_state_override)
  end
end

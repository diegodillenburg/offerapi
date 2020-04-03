class UpdateOffersState
  attr_reader :status

  def self.call
    new.call
  end

  def initialize
    @status = false
  end

  def call
    @status = true if Offer.where("starts_at <= ?", DateTime.now).update_all(state: :enabled)

    @status
  end
end

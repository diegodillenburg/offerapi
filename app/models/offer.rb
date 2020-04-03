class Offer < ApplicationRecord
  before_create :check_state

  enum state: %i[disabled enabled]

  validates :advertiser_name, presence: true, uniqueness: true
  validates :url, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :starts_at, presence: true

  validates_format_of :url, with: /(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?/ix

  validates_with DateValidator

  private

  def check_state
    self.starts_at <= DateTime.now ? self.state = :enabled : self.state = :disabled
  end
end

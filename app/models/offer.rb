class Offer < ApplicationRecord
  scope :enabled, -> { self.enabled_query }
  validates :advertiser_name, presence: true, uniqueness: true
  validates :url, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :starts_at, presence: true

  validates_format_of :url, with: /(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?/ix

  validates_with DateValidator

  private

  def self.enabled_query
    self.where("starts_at <= ?", DateTime.now)
        .where("ends_at > ? OR ends_at IS NULL", DateTime.now)
        .where(admin_state_override: false)
        .order(premium: :desc)
        .order(starts_at: :asc)
  end
end

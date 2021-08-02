class Announcement < ApplicationRecord
  has_one_attached :photo

  validates :title, presence: true
  validates :description, presence: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  validates :photo, attached: true, content_type: [:png, :jpg, :jpeg]
end

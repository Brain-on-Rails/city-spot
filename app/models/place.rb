class Place < ApplicationRecord
  has_many :list_places
  has_many :lists, through: :list_places
  belongs_to :creator, class_name: "User"
  has_many_attached :images, dependent: :purge_later

  # validates :images, content_type: ["image/jpeg", "image/png"]
  validates :images, size: { less_than: 5.megabytes }, content_type: ["image/jpeg", "image/png"]
  validate -> { images_count_within_limit(8) }
  validates :name, presence: true, length: { maximum: 255, minimum: 3 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 1000 }
  validates :geom, presence: true

  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }


  attr_accessor :latitude, :longitude
  before_validation :update_geom

  # def geom=(value)
  #   raise ArgumentError, "Use latitude and longitude instead of setting geom directly"
  # end

  private

  def images_count_within_limit(limit)
    if images.attached? && images.count > limit
      errors.add(:images, :too_many, max: limit)
    end
  end
  def update_geom
    return if latitude.blank? || longitude.blank?
    self[:geom] = FACTORY_GEOM.point(latitude, longitude)
  end

end

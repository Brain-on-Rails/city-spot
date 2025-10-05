class Place < ApplicationRecord
  has_many :list_places
  has_many :lists, through: :list_places
  belongs_to :creator, class_name: "User"

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255, minimum: 3 }
  validates :geom, presence: true

  def latitude
    geom&.y
  end

  def longitude
    geom&.x
  end

  def latitude=(value)
    self.geom = FACTORY_GEOM.point(longitude, value)
  end

  def longitude=(value)
    self.geom = FACTORY_GEOM.point(value, latitude)
  end

end

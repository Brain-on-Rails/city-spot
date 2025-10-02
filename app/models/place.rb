class Place < ApplicationRecord
  has_many :list_places
  has_many :lists, through: :list_places
  belongs_to :creator, class_name: "User"

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :geom, presence: true

end
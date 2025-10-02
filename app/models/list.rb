class List < ApplicationRecord
  has_many :list_places
  has_many :places, through: :list_places
  belongs_to :user

  validates :name, presence: true
end

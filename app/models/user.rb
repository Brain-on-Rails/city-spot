class User < ApplicationRecord
  has_many :lists
  has_many :created_places, class_name: "Place", foreign_key: "creator_id"

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  validates_email_format_of :email
end
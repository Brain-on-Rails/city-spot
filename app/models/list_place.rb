class ListPlace < ApplicationRecord
  belongs_to :list
  belongs_to :place
end

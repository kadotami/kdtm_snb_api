class Todo < ApplicationRecord
  validates :user_id, presence: true
  validates :title, presence: true
  validates :limit, presence: true
end

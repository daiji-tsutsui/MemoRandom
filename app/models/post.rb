class Post < ApplicationRecord
  belongs_to :user

  # validates :name
  validates :memo, presence: true

  mount_uploader :memo, MemoUploader
end

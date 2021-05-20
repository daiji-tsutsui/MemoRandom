class Post < ApplicationRecord
  belongs_to :user

  # validates :name
  # validates :memo

  mount_uploader :memo, MemoUploader
end

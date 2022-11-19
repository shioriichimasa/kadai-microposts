class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 255 }
  
  # # 自分がお気に入りしているMicropostへの参照
  # has_many :favorites
  # # 「Micropostをお気に入りしているUser」への参照
  # has_many :likeusers, through: :favorites

end

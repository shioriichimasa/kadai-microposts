class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  # 一対多：1ユーザーは多数の投稿を持っている
  has_many :microposts
  # 多対多の図の右半分にいる自分がフォローしているUserへの参照
  has_many :relationships

  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
 
  
  
  # フォローアンフォローメソッド
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  

   # お気に入りしている投稿とユーザーの中間テーブル
  has_many :favorites
  # お気に入り登録した投稿を取得
  # likesは自分で命名
  has_many :likes, through: :favorites, source: :micropost
  
  # likeはお気に入り登録／unlikeはお気に入り登録解除
  def like(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end

  def unlike(micropost)
    # お気に入りし登録していれば、お気に入りを外す
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  # お気に入りしているかどうかをBooleanで返す
  def like?(micropost)
    # self.likesでお気に入り登録してる投稿を取得し、indclude(micropost)でその投稿がお気に入りに含まれているかを確認
    self.likes.include?(micropost)
  end

end
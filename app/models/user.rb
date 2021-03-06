class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events, dependent: :destroy
  has_many :matches, dependent: :destroy

  has_attached_file :avatar, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "/assets/missing.svg.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower





  def follow(other)
  active_relationships.create(followed_id: other.id)
end


  def unfollow(other)
  active_relationships.find_by(follower_id: other.id).destroy
end


  def following?(other)
  following.include?(other)
    end
  end

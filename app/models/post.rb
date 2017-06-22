class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: { minimum: 5 }
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  before_save :generate_slug

  def count_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def generate_slug
    number = Post.where(title: self.title).length
    slug = self.title.downcase.strip.gsub(/[^0-9a-z ]/, '').gsub(/\s+/, '-')

    self.slug = number.zero? ? slug : slug + number.to_s
  end

  def to_param
    self.slug
  end
end
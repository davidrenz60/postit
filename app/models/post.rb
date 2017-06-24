class Post < ActiveRecord::Base
  include Voteable

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: { minimum: 5 }
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  before_save :generate_slug

  def generate_slug
    new_slug = to_slug(self.title)
    post = Post.find_by(slug: new_slug)
    count = 2

    while post && post != self
      new_slug = append_suffix(new_slug, count)
      count += 1
      post = Post.find_by(slug: new_slug)
    end

    self.slug = new_slug
  end

  def append_suffix(str, count)
    arr = str.split('-')

    if arr.last.to_i != 0
      return arr.slice(0...-1).join('-') + '-' + count.to_s
    else
      return arr.join('-') + '-' + count.to_s
    end
  end

  def to_slug(str)
    str.downcase.strip.gsub(/[^0-9a-z\s]/, '').gsub(/\s+/, '-')
  end

  def to_param
    self.slug
  end
end
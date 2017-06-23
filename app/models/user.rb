class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: { minimum: 5 }

  before_save :generate_slug

  def generate_slug
    new_slug = to_slug(self.username)
    user = User.find_by(slug: new_slug)
    count = 2

    while user && user != self
      new_slug = append_suffix(new_slug, count)
      count += 1
      user = User.find_by(slug: new_slug)
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
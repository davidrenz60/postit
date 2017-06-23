class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true

  before_save :generate_slug

  def generate_slug
    new_slug = to_slug(self.name)
    category = Category.find_by(slug: new_slug)
    count = 2

    while category && category != self
      new_slug = append_suffix(new_slug, count)
      count += 1
      category = Category.find_by(slug: new_slug)
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
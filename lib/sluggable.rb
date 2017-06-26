module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    class_attribute :slug_column
  end

  def generate_slug!
    new_slug = to_slug(self.send(self.class.slug_column.to_sym))
    obj = self.class.find_by(slug: new_slug)
    count = 2

    while obj && obj != self
      new_slug = append_suffix(new_slug, count)
      count += 1
      obj = self.class.find_by(slug: new_slug)
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

  module ClassMethods
    def slugable_column(col_name)
      self.slug_column = col_name
    end
  end
end
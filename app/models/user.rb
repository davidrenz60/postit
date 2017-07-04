class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: { minimum: 5 }

  sluggable_column :username

  def admin?
    self.role == 'admin'
  end

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, '%06d' % rand(10 ** 6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    # account_sid
    # auth_token
    # client = Twilio::REST::Client.new account_sid, auth_token
    # from

    # client.account.messages.create(
    #   from: from,
    #   to: "#{self.phone}",
    #   body: "Your Postit pin is #{self.pin}"
    # )
  end
end

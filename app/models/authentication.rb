class Authentication < ActiveRecord::Base
  attr_accessible :access_token, :access_secret, :expires_at, :service_type, :uid

  has_many :reserves, dependent: :destroy
  has_many :feeds, through: :reserves

  validates :access_token , presence: true, uniqueness: { scope: :service_type }
  #validates :access_secret, presence: false # should be true when service_type == twitter
  validates :service_type , presence: true
  validates :uid          , presence: true, uniqueness: { scope: :service_type }

  def profile_icon_url
    case self.service_type
    when 'facebook'
      "https://graph.facebook.com/#{self.uid}/picture"
    when 'twitter'
      "https://api.twitter.com/1/users/profile_image?user_id=#{self.uid}"
    end
  end

  def facebook
    @facebook = FbGraph::User.me(self.access_token)
  end
end

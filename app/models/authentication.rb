class Authentication < ActiveRecord::Base
  attr_accessible :access_token, :access_secret, :expires_at, :service_type, :uid

  has_many :reserves, dependent: :destroy
  has_many :feeds, through: :reserves

  def profile_icon_url
    case self.service_type
    when 'facebook'
      "https://graph.facebook.com/#{self.uid}/picture"
    when 'twitter'
      "https://api.twitter.com/1/users/profile_image?user_id=#{self.uid}"
    end
  end
end

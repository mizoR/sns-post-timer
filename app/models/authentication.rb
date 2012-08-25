class Authentication < ActiveRecord::Base
  attr_accessible :access_token, :expires_at, :service_type, :uid

  def profile_icon_url
    "https://graph.facebook.com/#{self.uid}/picture"
  end
end

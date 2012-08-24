class Authentication < ActiveRecord::Base
  attr_accessible :access_token, :expires_at, :service_type, :uid
end

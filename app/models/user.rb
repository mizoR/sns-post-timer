class User < ActiveRecord::Base
  attr_accessible :encrypted_password, :salt, :username, :password
  attr_accessor :password

  has_many :authentications, dependent: :destroy
  has_many :feeds,           dependent: :destroy

  def password=(password)
    @password = password
    if @password
      arr = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      self.salt = Array.new(32) { arr[rand(arr.size)] }.join
      self.encrypted_password = encrypted(@password, self.salt)
    else
      self.salt = nil
      self.encrypted_password = nil
    end
  end

  def authentication?(password)
    if password && self.salt
      self.encrypted_password == encrypted(password, self.salt)
    end
  end

  def encrypted(password, salt)
      Digest::MD5.hexdigest(password + salt)
  end
end

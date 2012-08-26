class Feed < ActiveRecord::Base
  attr_accessible :description, :link, :message, :name, :picture

  has_many :reserves, autosave: true
  has_many :authentications, through: :reserves

  validates :message, presence: true
end

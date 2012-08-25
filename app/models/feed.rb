class Feed < ActiveRecord::Base
  attr_accessible :description, :link, :message, :name, :picture

  has_many :reserves, autosave: true
end

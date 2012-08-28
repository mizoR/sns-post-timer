class Feed < ActiveRecord::Base
  attr_accessible :description, :link, :message, :name, :picture

  has_many :reserves, autosave: true
  has_many :authentications, through: :reserves

  validates :message, presence: true

  def self.from_url(url)
    doc  = Nokogiri::HTML(open(url))
    link        = url
    params = {}
    [:title, :image, :description].each do |key|
      dom = doc.css("meta[property='og:#{key}']")[0]
      params[key] = dom.attributes['content'].value.presence if dom && dom.attributes['content']
    end
    self.new(link: link, name: params[:title], picture: params[:image], description: params[:description])
  end
end

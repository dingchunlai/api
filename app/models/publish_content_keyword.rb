class PublishContentKeyword < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :url
  belongs_to :publish_content
end

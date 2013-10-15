class AfpPage < ActiveRecord::Base
  # relationships
  has_many :ads, :class_name => 'AfpAd', :dependent => :destroy

  # validations
  validates_presence_of :title, :url
  validates_uniqueness_of :title
end

__END__

CREATE TABLE afp_pages (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(50) NOT NULL COMMENT '页面名称',
  url  VARCHAR(1000) NOT NULL COMMENT 'url地址的正则匹配模式'
) ENGINE InnoDB CHARACTER SET utf8;

# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 11
#
# Table name: article_images
#
#  id           :integer(11)     not null, primary key
#  product_id   :integer(11)
#  parent_id    :integer(11)
#  title        :string(255)
#  filename     :string(255)
#  content_type :string(255)
#  thumbnail    :string(255)
#  size         :integer(11)
#  width        :integer(11)
#  height       :integer(11)
#  is_primary   :boolean(1)
#  createdate   :timestamp
#

class ArticleImage < ActiveRecord::Base
  belongs_to :brand,
  :class_name => "Article",
  :foreign_key => "article_id"
  

  has_attachment :content_type => :image,
  :storage => :file_system,
  :path_prefix => "public/files/hekea/article_img/sourceImage",
  # :size => 1.kilobytes .. 2.megabytes,
  :max_size => 500.kilobyte,
  :thumbnails => { :thumb => '240x160', :medium => '480x320',

}
  validates_as_attachment
  private
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    custom_path = Time.now.strftime("%Y%m%d").to_s
    File.join(RAILS_ROOT, file_system_path, custom_path, thumbnail_name_for(thumbnail))
  end

  def uploaded_data=(file_data)
    super
    now = Time.now
    self.filename = 'img'+now.strftime("%Y%m%d").to_s+now.to_i.to_s+File.extname(file_data.original_filename)
  end
end

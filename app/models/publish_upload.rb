class PublishUpload < ActiveRecord::Base
#  acts_as_readonlyable [:read_only_51hejia]
  has_attachment :storage => :file_system,
                   :path_prefix => "public/images",
                   :size => 1.kilobyte..2.megabytes,
                   :thumbnails => { :small=>'200x200>', :middle=>'400x400>' },
                   :content_type => ['image']
end

# == Schema Information
# Schema version: 11
#
# Table name: binaries
#
#  id           :integer(11)     not null, primary key
#  title        :string(255)
#  content_type :string(255)
#  filename     :string(255)
#  size         :integer(11)
#

class Binary < ActiveRecord::Base
  has_attachment :content_type => ['application/octet-stream', :image],
  :storage => :file_system,
  :path_prefix => "public/images/binary",
  :max_size => 500.kilobytes,
  :resize_to => '700x500>',
  :processor => :Rmagick

  after_attachment_saved do |record|
    # Don't add watermarks to thumbnails
    begin
    full_path = File.join(RAILS_ROOT, 'public/', record.public_filename)
    watermark_path = File.join(RAILS_ROOT, 'public/', 'images/watermark_logo.png')
    if File.exists?(full_path) && File.exists?(watermark_path)
      dst = Magick::ImageList.new(full_path).first
      src = Magick::Image.read(watermark_path).first
      result = dst.composite(src, Magick::SouthWestGravity, Magick::OverCompositeOp)
      result.write(full_path)
    end
    rescue

    end
  end

  def self.water_mark full_path, watermark_path
    if File.exists?(full_path) && File.exists?(watermark_path)
      begin
        dst = Magick::ImageList.new(full_path).first
        src = Magick::Image.read(watermark_path).first
        result = dst.composite(src, Magick::SouthWestGravity, Magick::OverCompositeOp)
        result.write(full_path)
      rescue Magick::ImageMagickError
        puts "--------------------"
        puts "#{$0}: ImageMagickError - #{$!}"
      rescue => e
      puts "++++++++++++++++++++ error ++++"
      puts e
      end
    end
  end
  #start 可以控制位置的水印方法
  def self.water_mark_state full_path, watermark_path,state
    if File.exists?(full_path) && File.exists?(watermark_path)
      begin
        dst = Magick::ImageList.new(full_path).first 
        src = Magick::Image.read(watermark_path).first 
        
        if state.to_i==1 #左下角
          logger.info "=========================左下角======================================="
          result = dst.composite(src, Magick::SouthWestGravity, Magick::OverCompositeOp) 
        elsif state.to_i==2 #左上角 
          logger.info "=========================左上角 ======================================="
          result = dst.composite(src, Magick::NorthWestGravity, Magick::OverCompositeOp) 
        elsif state.to_i==3 #右下角 
          logger.info "=========================右下角 ======================================="
          result = dst.composite(src, Magick::SouthEastGravity, Magick::OverCompositeOp) 
        elsif state.to_i==4 #右上角 
          logger.info "=========================右上角======================================="
          result = dst.composite(src, Magick::NorthEastGravity, Magick::OverCompositeOp)  
        elsif state.to_i==5 #中间
          logger.info "=========================中间======================================="
          logger.info "watermark_path:"+watermark_path.to_s
        result = dst.composite(src, Magick::CenterGravity, Magick::OverCompositeOp)  
        else 
          logger.info "=========================默认坐下======================================="
          result = dst.composite(src, Magick::SouthWestGravity, Magick::OverCompositeOp)#默认坐下 
        end 
        result.write(full_path) 
        logger.info "=========================end:::::::::::::::::::::======================================="
      rescue Magick::ImageMagickError
        puts "--------------------"
        puts "#{$0}: ImageMagickError - #{$!}"
      rescue => e
      puts "++++++++++++++++++++ error ++++"
      puts e
      end
    end
  end
#  end
  def self.manual_water_mark image_path, logo_path, width, height, left, top
    begin
      image = Magick::ImageList.new(image_path).first
      logo = Magick::Image.read(logo_path).first
      new_logo = logo.resize(width, height)
      # new_image = image.composite(new_logo, Magick::SouthWestGravity, Magick::OverCompositeOp)
      new_image = image.composite(new_logo, left, top, Magick::OverCompositeOp)
      new_image.write(image_path)
    rescue Magick::ImageMagickError
      puts "--------------------"
      puts "#{$0}: ImageMagickError - #{$!}"
    rescue => e
      puts "++++++++++++++++++++manual water error ++++"
      puts e
    end
  end
  validates_as_attachment
end



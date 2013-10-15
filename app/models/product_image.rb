class ProductImage < Hejia::Db::HejiaProduct
#  include ProductConn
#  acts_as_readonlyable [:read_only_51hejia_product]
  def full_path(thumbnail = nil)
    path_prefix = "http://d.51hejia.com/files/hekea/img/"
    path = ""
    path << path_prefix
    if self.filename.length == 28
      path << self.filename[3,8]
      path << "/"
      path << "tn/" if thumbnail
      path << self.filename
    else
      #path << "/"
      path << (thumbnail ? (File.split(self.filename)[0] + "/tn/" + File.split(self.filename)[1]) : self.filename)
    end
    return path
  end
end

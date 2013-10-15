class Product < Hejia::Db::HejiaProduct
#  include ProductConn
#  acts_as_readonlyable [:read_only_51hejia_product]

  def self.recent_products
    key = "key_publish_recent_products_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = Product.find(:all,
        :select => "id, productid, name",
        :conditions => ["status = 1"],
        :order => "created_at DESC", :limit => 10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    result
  end
end

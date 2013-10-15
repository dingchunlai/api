class DecoVedio < ActiveRecord::Base
  acts_as_readonlyable [:read_only_51hejia]
  
  def self.get_vedio_by_companyid(companyid)
    key = "zhaozhuangxiu_gongsishipin_#{Time.now.strftime('%Y%m%d%H')}_#{companyid}"
    if CACHE.get(key).nil?
      result = find(:first,:conditions => "firm_id = '#{companyid}' and tuijian = '1'",:select => "id")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result  
  end
end


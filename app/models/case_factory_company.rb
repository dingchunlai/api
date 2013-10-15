class CaseFactoryCompany < Hejia::Db::Hejia
#  acts_as_readonlyable [:read_only_51hejia]
  self.table_name = "HEJIA_FACTORY_COMPANY"
  self.primary_key = "ID"
  
  belongs_to :tagc,
  :class_name => "CaseTag",
  :foreign_key => "PROVINCE2"
  
  def self.getseoworksites
    key = "zhaozhuangxiu_worksites_index_seo_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result = find(:all,:conditions => "ENDENABLE > #{Time.now.strftime('%Y-%m-%d')}",:group => "COMPANYID", :limit => 10, :order => "id desc")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result 
  end  
  
  def self.get_company_worksites(id)
    key = "zhaozhuangxiu_worksites_company_detail_#{Time.now.strftime('%Y%m%d%H')}_#{id}"
    if CACHE.get(key).nil?
      result = find(:all,:conditions => "COMPANYID = #{id}",:limit => 5,:order => 'id desc',:include => 'tagc')
      if !result || result.size ==0
        result = []
      end
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
  
end

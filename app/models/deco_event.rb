class DecoEvent < Hejia::Db::Hejia
#  acts_as_readonlyable [:read_only_51hejia]
  
  include GeoKit::Geocoders
  acts_as_mappable :auto_geocode => true
  
  has_attached_file :banner,
  :path => ":rails_root/public/decos/:class/:attachment/:id/:basename_:style.:extension",
  :url => "http://image.51hejia.com/decos/:class/:attachment/:id/:basename_:style.:extension",
  :default_url => "/images/missing.gif"
  
  has_and_belongs_to_many :firms, :class_name => "DecoFirm",
  :join_table => "deco_events_firms",
  :foreign_key => "event_id",
  :association_foreign_key => "firm_id"
  has_many :registers, :class_name => "DecoRegister", :foreign_key => "event_id"
  has_many :remarks, :as => :resource, :order => "id DESC"
  
  def countdown
    if ends_at
      ends_at - Date.today
    else
      "-"
    end
  end
  
  # get now city events_and_firm_info
  def self.promoted_events(city)
    CACHE.fetch("deco_event/firm_events/praise/#{city}",1.hours) do
      DecoEvent.find(
        :all,
        :select => 'firm.id as firm_id,firm.praise as praise, deco_events.title as title , deco_events.id as event_id, firm.name_abbr as firm_name', 
        :conditions => [
          city.to_i == 11910 ? "deco_events.ends_at > ? and firm.city = ?" : "deco_events.ends_at > ? and firm.district = ?",
          Time.now, city
        ], 
        :joins => "join deco_events_firms as event_firm on deco_events.id = event_firm.event_id join deco_firms as firm on firm.id = event_firm.firm_id",
        :group => "firm.id",
        :order => "firm.is_cooperation desc, deco_events.updated_at desc",
        :limit => 10
      )
    end
  end
  
  def self.getseoevents
    key = "zhaozhuangxiu_seo_events_#{Time.now.strftime('%Y%m%d%H')}"
    result = nil
    if CACHE.get(key).nil?
      result =  find(:all,:select => "title,id,starts_at",:order => "id desc",:limit=>10)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result    
  end
  
  def self.getnewevents(firmid)
    key = "zhaozhuangxiu_seo_events_#{Time.now.strftime('%Y%m%d%H')}_#{firmid}"
    if CACHE.get(key).nil?
      result =  DecoEvent.find_by_sql("select d.*  from deco_events as d,deco_events_firms as l where l.firm_id=#{firmid} and d.id=l.event_id order by d.id desc limit 1")
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
   return result
  end
  
  def self.get_index_events
    key = "zhaozhuangxiu_index_events_100111_#{Time.now.strftime('%Y%m%d%H')}_1"
    
    if CACHEZ.get(key).nil?
      result =  DecoEvent.find(:all,:order => "id desc",:limit=>6)
      CACHEZ.set(key,result)
    else
      result = CACHEZ.get(key)
    end 
    
    return result   
  end
end

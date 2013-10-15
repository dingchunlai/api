class HejiaUserBbs < Hejia::Db::Hejia
  self.table_name = "HEJIA_USER_BBS"
  self.primary_key = "USERBBSID"
#  acts_as_readonlyable [:read_only_51hejia]

  validates_presence_of :USERNAME, :message => "用户名不能为空"
  validates_uniqueness_of :USERNAME, :message => "用户名已经存在"
  
  attr_protected :mobile_verified
  
  has_many :decoration_diaries, :class_name => "DecorationDiary", :foreign_key => "user_id"

  def self.gettopten
    CACHE.fetch("zhaozhuangxiu_hejia_user_bbs_id_topten_1_#{Time.now.strftime('%Y%m%d%H')}2", 1.hour) do
      HejiaUserBbs.find(:all,:select=>"USERBBSID, USERNAME, POINT",:conditions =>"USERTYPE = 100", :order => "POINT desc", :limit => 10)
    end
  end

  #会员登录验证
   def self.authenticate(name, password)
    HejiaUserBbs.find(:first, :select => "userbbsid, deco_id, freeze_date",
      :conditions => ["username = ? and userspassword = ?", name, md5(password)])
  end
  
  def self.hejia_bbs_user id
    CACHE.fetch("/hejia_user_bbs/user/#{id}", 2.day) do
      HejiaUserBbs.find_by_USERBBSID id
    end
  end
  
  
  
  def self.has_many_hejia_bbs_user_number
    CACHE.fetch("/has_many_hejia_bbs_user_number/export", 1.day) do
      HejiaUserBbs.count(:all, :conditions => ["USERTYPE = 100"])
    end
  end
  
   #得到当前用户发表图片，日记PV，日记留言的总数
  def self.get_user_count_sum(user_id)
    CACHE.fetch("get_user_photos/pictures/#{user_id}",5.hours) do
      diaries =  DecorationDiary.find(:all,:select => "id",:conditions =>"user_id = #{user_id}")
      photos_count = 0 #图片总数
      remark_count = 0 #日记留言的总数
      pv_count = 0 #日记PV总数
      diaries.each do |d|
        photos_count += d.pictures.size
        remark_count += d.remarks.size
        pv_count += d.pv.to_i
      end
       count_sum = [photos_count,remark_count,pv_count]
    end
  end
  
end

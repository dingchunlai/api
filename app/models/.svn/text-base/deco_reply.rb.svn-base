class DecoReply < ActiveRecord::Base
  self.table_name = "51hejia.radmin_fdatas"
  
  alias_attribute :review_id, :c1                 #回应的评论id
  alias_attribute :user_id, :c2                   #回应人id
  alias_attribute :replytype, :c3                 #回应类型(1:回应，2：举报)
  alias_attribute :username, :c4                  #用户名
  alias_attribute :userurl, :c5                   #用户头像
  alias_attribute :content, :c30                  #评论内容 
  alias_attribute :type, :c34                     #标记活动 1, 活动 2,报价单回应

  belongs_to :user,
  :class_name => "HejiaUserBbs",
  :foreign_key => "c2"
  
  def self.getreplies(reviewid,replytype) 
    return DecoReply.find(:all,:conditions=>"formid = '#{HUIFU_ID}' and c1 = '#{reviewid}' and c3 = '#{replytype}' ",:order => "id desc",:limit=>10)
  end 
  
  def self.getrepliescount(reviewid,replytype)
    return DecoReply.count(:all,:conditions=>"formid = '#{HUIFU_ID}' and c1 = '#{reviewid}' and c3 = '#{replytype}' ")
  end
  def self.getreplybyids(reviewids,replytype)
    return DecoReply.find(:all,:conditions=>"formid = '#{HUIFU_ID}' and c1 in (#{reviewids}) and c3 = '#{replytype}' ",:order => "id desc",:limit=>10)
  end
  def self.getreplybyidscount(reviewids,replytype)
    return DecoReply.count(:all,:conditions=>"formid = '#{HUIFU_ID}' and c1 in (#{reviewids}) and c3 = '#{replytype}' ")
  end
  def self.getreplies_asc(page,reviewid,replytype) 
    return DecoReply.paginate :page => page, :per_page =>10, :conditions=>"formid = '#{HUIFU_ID}' and c1 = '#{reviewid}' and c3 = '#{replytype}' ",:order => "id asc"
  end
  
  #得到装修优惠券回应列表
  def self.get_events_reply_byc1_1_and_c34_count(page,reviewids,replytype,type)
    return DecoReply.paginate :page => page, :per_page =>10, :conditions=>"formid = '#{HUIFU_ID}' and c1 in (#{reviewids}) and c3 = '#{replytype}' and c34 = '#{type}' ",:order => "id desc"
  end
  
end


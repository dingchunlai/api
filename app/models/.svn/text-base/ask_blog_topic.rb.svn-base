class AskBlogTopic < ActiveRecord::Base
  self.table_name = "ask_blog_choices"
  def self.recent_logs
    key = "key_publish_recent_blogs_#{Time.now.strftime('%Y%m%d%H')}"
    if CACHE.get(key).nil?
      result = AskBlogTopic.find(:all,
        :conditions => ["sort_id = 6 and is_valid = 2"],
        :order => "order_number DESC, updated_at DESC", :limit => 5)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    result
  end
end

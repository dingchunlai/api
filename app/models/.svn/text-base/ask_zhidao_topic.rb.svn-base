class AskZhidaoTopic < ActiveRecord::Base

  def title(length=99)
    strs = read_attribute("subject").to_s.split(//u)
    strs[0...length].join
  end

  def url
    "http://wb.51hejia.com/q/#{id}.html"
  end

  #问吧最新帖子
  def self.recent_topics(limit=5)
    max_limit = 10
    fail "limit最大不能超过max_limit" if limit > max_limit
    key = "ask_zhidao_topics_recent_topics"
    topics = CACHE.fetch(key, 2.hours) do
      AskZhidaoTopic.find(:all,
        :select => "id, subject, left(description,150) as description",
        :conditions => ["is_delete = 0 and is_distribute = 1"],
        :order => "created_at DESC", :limit => max_limit)
    end
    topics[0...limit]
  end
  
end

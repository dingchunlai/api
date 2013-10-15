class SalesPromotionEvent < Hejia::Db::Product

#  establish_connection "product2_#{ENV['RAILS_ENV']}".to_sym

  def title
    read_attribute("subject")
  end

  def url
    "http://www.51hejia.com/huodong/#{id}"
  end

  class << self

    def unexpired_events(limit, city = '')
      max_limit = 10
      fail '参数limit不能大于max_limit' if limit > max_limit
      memkey = "sales_promotion_event_unexpired_events_2_#{max_limit}_#{city}"
      events = CACHE.fetch(memkey, 3.hours) do
        cond = ["ends_at >= '#{Time.now.to_s(:db)}'"]
        cond << "city = '#{city}'" unless city.blank?
        SalesPromotionEvent.find(:all,:select => 'id,subject,city',
          :conditions => cond.join(' and '),
          :order => "ends_at desc",
          :limit => max_limit)
      end
      events[0...limit]
    end

  end

end

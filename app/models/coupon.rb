class Coupon < Hejia::Db::Product

  COUPON_CITIE_PINYIN = {1 => 'shanghai', 2 => 'nanjing', 132 => 'suzhou', 223 => 'hangzhou', 131 => 'wuxi', 214 => 'ningbo'}

  # 根据城市来查询抵用卷信息，按最新来排
  named_scope :with_city_limit, lambda {|city, limit|
    {
      :select => "id, title, city_id",
      :conditions => ["coupons.status = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ? and city_id=?", 1, Time.now, Time.now, city],
      :limit => limit,
      :order => "coupons.activity_began_at DESC"
    }
  }

  # 根据标签来查询抵用卷信息，按下载量来排行
  named_scope :with_tagid_limit, lambda {|tagid, limit|
    {
      :select => "id, title, city_id, downloads_count",
      :conditions => ["coupons.status = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ? and tag_id=?", 1, Time.now, Time.now, tagid],
      :limit => limit,
      :order => "coupons.downloads_count DESC"
    }
  }

  named_scope :with_tagid_and_city_id_limit, lambda {|city_id, tagid, limit|
    {
      :select => "id, title, city_id, downloads_count, total_issue_number, virtual_existing_number, (total_issue_number-virtual_existing_number) as def_value",
      :conditions => ["coupons.status = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ? and tag_id=? and city_id = ?", 1, Time.now, Time.now, tagid, city_id],
      :limit => limit,
      :order => "def_value DESC"
    }
  }

  def url
    "http://#{COUPON_CITIE_PINYIN[city_id]}.youhui.51hejia.com/coupon/#{id}"
  end

end
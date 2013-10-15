class AfpAd < ActiveRecord::Base
  VISITS_RATE_BY_HOUR = [2.59, 1.14, 0.68, 0.45, 0.44, 0.47, 0.88, 1.46, 3.34, 5.31, 6.47, 6.22, 5.01, 5.50, 6.21, 6.73, 6.84, 5.65, 4.46, 5.14, 6.53, 7.35, 6.69, 4.43]
  # relationships
  belongs_to :page, :class_name => 'AfpPage'

  # validations
  validates_presence_of :afp_page_id, :ad_id, :p1, :p2, :rate, :started_at, :ended_at
  validates_uniqueness_of :ad_id
  validates_inclusion_of :rate, :in => 0.0..1.0
  #validates_format_of :max_hits, :with => /^\d+$/, :message => "最大点击数必须为数字" #允许为零
  validates_inclusion_of :max_hits, :in => 0..99999, :message => "最大点击数必须为数字" #允许为零
  validates_inclusion_of :floating_rate,:in => 1..99, :message => "浮动率 1-99 之间"

  validate do |ad|
    ad.errors.add :ended_at, '结束日期必须小于开始日期' unless ad.ended_at.nil? || ad.started_at.nil? || ad.ended_at >= ad.started_at
  end

  after_save :update_click_stat_by_day

  class << self
    # 根据传入url，返回符合这个url的广告
    def find_by_url(url)
      matched_page =
        AfpPage.find(:all, :select => 'id, url', :order => 'id').detect do |page|
          %r/#{page.url}/ === url
        end

      return [] unless matched_page

      matched_page.ads.find :all,
                            :select => 'ad_id, p1, p2, rate, max_hits, floating_rate, link, limited_access_location',
                            :conditions => [
                              '? between started_at and ended_at',
                              Date.today
                            ]
    end

    def get_hours_hits(max_hits, floating_rate)
      if rand > 0.5
        max_hits += max_hits * (floating_rate.to_f / 100.to_f)
      else
        max_hits -= max_hits * (floating_rate.to_f / 100.to_f)
      end
      hash = AfpAd::VISITS_RATE_BY_HOUR.each_with_index.inject({}) { |hash, (item,index)| hash["hour#{index}".to_sym]= (max_hits.to_f * item / 100.0 ).round; hash }
      hash.update(:max_hits => max_hits)
    end

    def clear_expired_ads
      destroy_all 'ended_at < now()'
    end
  end # end class methods

  def update_click_stat_by_day
    if self.ended_at >= Time.now.to_date and self.started_at <= Time.now.to_date and self.max_hits != 0
      stat = AfpAdStat.find(:first,
                            :conditions => ['ad_id = ? and stat_date = ?',
                                            self.ad_id,
                                            Time.now.to_date])
      if stat
        stat.update_attributes(AfpAd.get_hours_hits(self.max_hits, self.floating_rate))
      else
        AfpAdStat.create({:ad_id => self.ad_id, :stat_date => Time.now.to_date}.update(AfpAd.get_hours_hits(self.max_hits, self.floating_rate)))
      end
    end
  end

  def access_limited?
    !(limited_access_location.blank? || limited_access_location == '不限制')
  end

  def can_access_from?(city)
    !access_limited? || limited_access_location == city
  end
end

__END__

use 51heia;

CREATE TABLE afp_ads (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  url VARCHAR(1000) NOT NULL COMMENT 'url地址的正则匹配模式',
  ad_id INTEGER UNIQUE NOT NULL COMMENT '广告在广告系统中的id',
  p1 INTEGER NOT NULL COMMENT '广告点击参数1',
  p2 INTEGER NOT NULL COMMENT '广告点击参数2',
  rate DECIMAL(3, 2) NOT NULL COMMENT '广告点击率',
  link VARCHAR(255) COMMENT '广告点击后最终的到达地址',
  started_at DATE NOT NULL COMMENT '生效日期',
  ended_at DATE NOT NULL COMMENT '结束日期',

  afp_page_id INTEGER REFERENCES afp_pages(id) ON DELETE CASCADE
) ENGINE InnoDB CHARACTER SET utf8;

CREATE INDEX afp_ads_url_index ON afp_ads(url);
CREATE INDEX afp_ads_afp_page_id_index ON afp_ads(afp_page_id);

-- 2010-12-21 add_limited_access_location
ALTER TABLE afp_ads ADD COLUMN limited_access_location varchar(50);

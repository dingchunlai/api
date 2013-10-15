class AnalogCode < ActiveRecord::Base
  VISITS_RATE_BY_HOUR = [2.59, 1.14, 0.68, 0.45, 0.44, 0.47, 0.88, 1.46, 3.34, 5.31, 6.47, 6.22, 5.01, 5.50, 6.21, 6.73, 6.84, 5.65, 4.46, 5.14, 6.53, 7.35, 6.69, 4.43]

  has_many :analog_code_urls, :class_name => "AnalogCodeUrl", :finder_sql => 'select distinct analog_code_urls.* from analog_code_urls where analog_code_urls.code = \'#{code}\'', :dependent => :destroy
  has_many :analog_urls, :class_name => "AnalogUrl", :finder_sql => 'select distinct analog_urls.* from analog_urls where analog_urls.code = \'#{code}\'', :dependent => :destroy

  ## 今日点击量
  def today_analog_urls
    #AnalogUrl.find(:all, :conditions => ["code = ? and created_at > ?", self.code, (Time.now.at_beginning_of_day - 8 * 60 * 60)])
    AnalogUrl.find(:all, :conditions => ["code = ? and created_at > ?", self.code, Time.now.at_beginning_of_day])
  end

  ## 当前可以模拟点击的次数
  def current_can_hits
    current_hour = Time.now.hour
    last_count = 23 - current_hour
    ## 计算出当前小时和当前小时前所有可以的模拟点击数
    (self.max_hits - VISITS_RATE_BY_HOUR.last(last_count).sum * self.max_hits / 100).to_i
  end

  ## 判断当前时间是否可以模拟点击
  def current_hour_can_hit?
    can_hit = false
    self.reload
    can_hit = true if self.current_can_hits > self.today_analog_urls.count
    can_hit
  end
end

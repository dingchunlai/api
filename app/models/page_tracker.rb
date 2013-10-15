# 页面跟踪
# 记录页面的访问量(pv)。
# 参考StatController#page_track
class PageTracker
  class << self
    def track(url, options = nil)
      new(url, options).track!
    end

    def count_for(url)
      new(url).count
    end
  end

  def initialize(url, options = nil)
    @url   = standalize_url url
    @trick = options.respond_to?(:[]) && options[:trick] || options.respond_to?(:trick) && options.trick
  end

  def track!
    REDIS_DB.incrby counter_key, increment
  end

  def count
    REDIS_DB.get(counter_key).to_i
  end

  private

  def standalize_url(url)
    url.split('?', 2).first
  end

  def counter_key
    "page_track:#{Digest::MD5.hexdigest(@url)}"
  end

  def increment
    case @trick
    when Range
      rand(@trick.min) + @trick.max - @trick.min
    when /\A(\d+)-(\d+)\z/
      rand($1.to_i) + $2.to_i - $1.to_i
    when String, Numeric
      rand @trick.to_i
    else
      1
    end
  end
end

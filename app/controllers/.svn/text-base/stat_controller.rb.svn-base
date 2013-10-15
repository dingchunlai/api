class StatController < ApplicationController

  before_filter :validate_referrer

  def dairy   
    if note ||= params[:id].blank? ? nil : DecorationDiary.getNote(params[:id])
      note.increase_pv!
      note.add_ip! request.remote_ip
    end
    send_empty_gif 
  end

  def deco_firm
    if firm ||= params[:id].blank? ? nil : DecoFirm.getfirm(params[:id])
      firm.increase_pv!
    end

    send_empty_gif
  end

  # 跟踪页面访问量。没有作任何ip或者cookies的控制。可以随便刷。
  # 跟踪页面时，忽略连接的所有参数。
  # 使用方法：
  # 在需要被跟踪的页面上加上：
  # <img src="http://api.51hejia.com/stat/page_track" style="display:none;">
  # 如果需要作弊。。。。。。为什么需要作弊？问销售去。
  # 加上t参数：
  # <img src="http://api.51hejia.com/stat/page_track?t=30" style="display:none;">
  # 上面的例子，就会在页面有一个访问的时候，随机增加[0,29)个访问量。
  # 也可以：
  # <img src="http://api.51hejia.com/stat/page_track?t=10-30" style="display:none;">
  # 则随机增加[10,30)个访问量。
  def page_track
    url = request.env['HTTP_REFERER']
    return head(404) if url.blank?

    respond_to do |format|
      # considered as a 'set'
      format.html do
        PageTracker.track url, :trick => params[:t]
        send_empty_gif
      end

      # considered as a 'get'
      format.json do
        count = PageTracker.count_for url
        if params[:callback] # jsonp
          render :text => <<-_JS_CODE_
(function() {
  #{params[:callback]}(#{count});
})();
          _JS_CODE_
        else
          render :json => count
        end
      end
    end
  end

  private

  def validate_referrer
    render :text => "What do you want, huh?", :status => 403 unless request.env['HTTP_REFERER'] =~ %r'^http://[^/]*\.51hejia\.com'
  end

  def send_empty_gif
    send_file File.join(RAILS_ROOT, 'public/empty.gif'), :type => 'inline'
  end

end

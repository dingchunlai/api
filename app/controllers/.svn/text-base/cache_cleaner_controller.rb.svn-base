class CacheCleanerController < ApplicationController
  
  before_filter :validates_request
  
  def index
    if request.post?
      case params[:submit]
      when 'Show'   then show
      when 'Delete' then delete
      end
    end
    render :text => cleaner_template
  rescue ArgumentError
    raise $! if @last_message && @last_message == $!.message
    @last_message = $!.message
    Object.const_get $!.message.split(' ')[-1]
    retry
  end

  def delete
    @message = with_keys do |key|
      CACHE.delete key
      "#{key} cleaned!"
    end
  end
  private :delete
  
  def show
    @message = with_keys { |key| "#{key}: #{CACHE[key].inspect}" }
  end
  private :show

  def with_keys
    '<ul><li>' +
    params[:key].split(',').map do |key|
      key.strip!
      yield key
    end.join('</li><li>') +
    '</li></ul>'
  end
  private :with_keys
  
  def validates_request
    page_not_found! unless (local_request? || request.remote_ip == '58.246.26.58') && (RAILS_ENV != 'production' || request.get? || params[:p] == 'hejia51!@')
  end
  private :validates_request
  
  def cleaner_template
<<_HTML_
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>cache cleaner</title>
  </head>
  <body>
    #{'<p>' + @message + '</p>' if @message}
    <form action="#{url_for}" method="post">
      <div>
        <label for="key">key:</label><textarea name="key" cols="80" rows="20"></textarea>
      </div>
      <div>
        <label for="p">password:</label><input type="password" name="p">
      </div>
      <div><input type="submit" name="submit" value="Show"><input type="submit" name="submit" value="Delete"></div>
    </form>
  </body>
</html>
_HTML_
  end
  private :cleaner_template

end

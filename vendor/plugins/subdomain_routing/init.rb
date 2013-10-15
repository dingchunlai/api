# require File.join(File.dirname(__FILE__), 'lib/subdomain_routing')
ActionController::Routing::RouteSet.class_eval do
  def extract_request_environment_with_host(request)
    env = extract_request_environment_without_host(request)
    env.merge :host => request.host,
              :domain => request.domain,
              :subdomain => request.subdomains.first
  end

  alias_method_chain :extract_request_environment, :host
end

ActionController::Routing::Route.class_eval do
  def recognition_conditions_with_host
    result = recognition_conditions_without_host
    result << "conditions[:host] === env[:host]" if conditions[:host]
    result << "conditions[:domain] === env[:domain]" if conditions[:domain]
    result << "conditions[:subdomain] === env[:subdomain]" if conditions[:subdomain]
    result
  end

  alias_method_chain :recognition_conditions, :host
end

# =======
ActionController::Base.class_eval do
  class_inheritable_accessor :subdomain_filter

  class << self
    def enable_subdomain_filter
      before_filter :subdomain_before_filter
    end

    def add_subdomain_filter(filter)
      self.subdomain_filter ||= {}

      filter.each do |subdomain, url_exps|
        case url_exps
        when Array
          url_exps.each { |url_exp| subdomain_filter[url_exp] = subdomain }
        else
          subdomain_filter[url_exps] = subdomain
        end
      end
    end

    def clear_subdomain_filter
      subdomain_filter.clear
    end
  end

  def subdomain_before_filter
    path, subdomain = request.path, request.subdomains.first

    subdomain_filter.each do |path_exp, sub|
      # 如果路径设定了访问子域名
      if path_exp === path
        # 那么，如果子域名一致，就可以访问
        if sub == subdomain
          return true
        else
          # 否则不允许访问
          render :nothing => true, :status => 404
          return false
        end
      end
    end

    # 如果路径没有处理，而且设置了:others的子域名，那么就必须符合:others的子域名
    if subdomain_filter[:others] && subdomain_filter[:others] != subdomain
      render :nothing => true, :status => 404
      return false
    end

    true
  end
end

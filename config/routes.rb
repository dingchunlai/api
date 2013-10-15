ActionController::Routing::SEPARATORS <<  "-" unless ActionController::Routing::SEPARATORS.include?("-")
ActionController::Routing::SEPARATORS <<  "," unless ActionController::Routing::SEPARATORS.include?(",")
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  map.resources :decofirms, :has_many => :remarks
  map.resources :decorationdiaries, :has_many => :remarks
  
  map.with_options :conditions => {:subdomain => 'd'} do |d|
    d.connect '/', :controller => 'index', :action => 'd_index'
  end
  
  map.resources :firms, :member => {:service => :get, :promotion => :get, :detail => :get} do |firm|
    firm.resources :worksites, :name_prefix => "firm_"
    firm.resources :diaries, :name_prefix => "firm_"
    firm.resources :events, :name_prefix => "firm_"
    firm.resources :quotations, :name_prefix => "firm_"
    firm.resources :photos, :name_prefix => "firm_", :collection => {:slide => :get}
    firm.resources :designers, :name_prefix => "firm_"
    firm.resources :cases, :name_prefix => "firm_"
  end
  map.resources :worksites, :collection => {:index => :get}
  map.resources :diaries
  #  map.resources :events, :member => {:register => :post}
  map.resources :photos
  map.connect '/zhuangxiugongsi/:cityname-gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/:page',:controller => 'firms', :action => 'index', :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiugongsi/:cityname-gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/',:controller => 'firms', :action => 'index', :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiugongsi/gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/:page',:controller => 'firms', :action => 'index', :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiugongsi/gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/',:controller => 'firms', :action => 'index', :conditions => { :subdomain => 'z' }
  
  # map.connect '/zhuangxiuzixun', :conditions => { :subdomain => 'z' }
  
  #  map.products_search '/firms/:brand.:category.:order.:page.:price.:type.html', :controller => "search", :action => "products"
  map.firms_filter 'zhuangxiugongsi/:district.:model.:style.:order.:price.:page.html', :controller => 'firms', :action => 'index', :conditions => { :subdomain => 'z' }
  map.newfirms_filter 'zhuangxiugongsi-:city-:district-:model-:style-:order-:price-:page/',:controller => 'firms', :action => 'index', :conditions => { :subdomain => 'z' }
  map.newfirms_filter 'zhuangxiugongsi-:city-:district-:model-:style-:order-:price-:hcase-:hcommont-:page/',:controller => 'firms', :action => 'index', :conditions => { :subdomain => 'z' }
  map.newdianping_filter 'dianping-:city-:district-:model-:style-:order-:price-:page/',:controller => 'firms', :action => 'index', :conditions => { :subdomain => 'z' }
  map.dianping_filter 'dianping-:city-:room-:price-:style-:page-:type', :controller => 'dianping', :action => 'indexnew', :conditions => { :subdomain => 'z' }
  #工装列表
  map.connect '/gongzhuang', :controller => "firms", :action => 'gongzhuang', :conditions => { :subdomain => 'z' }
  #别墅列表
  map.connect '/bieshu', :controller => "firms", :action => 'bieshu', :conditions => { :subdomain => 'z' }
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  #发布系统
  map.connect '', :controller => 'deco', :action => 'index_rewrite', :conditions => { :subdomain => 'z' }

  #  map.connect '', :controller => "admin", :action => "login"
  map.conncec 'redirect', :controller => 'deco', :action => 'index_rewrite', :conditions => { :subdomain => 'z' }

  #找装修
  #  map.connect '/dianpingbang', :controller => "ranking", :action => 'index', :conditions => { :subdomain => 'z' }
  map.connect '/events', :controller => "events", :action => 'index', :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiuhuodong', :controller => "events", :action => 'coupon_show', :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiuhuodong/:page', :controller => "events", :action => 'coupon_show', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/show/:id', :controller => "dianping", :action => 'show', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/new/:id', :controller => "dianping", :action => 'new', :conditions => { :subdomain => 'z' }
  #start (公司优惠跳转路径设置)----------------------------------------------
  map.connect '/dianping/add_youhuiquan_reply/:id', :controller => "dianping", :action => 'add_youhuiquan_reply', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/add_quotation_reply/:id', :controller => "dianping", :action => 'add_quotation_reply', :conditions => { :subdomain => 'z' }
  map.connect '/events/:id', :controller => "events", :action => "coupon", :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiuhuodong/:order/:types/:quyu', :controller => "events", :action => "coupon_show", :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiuhuodong/:order/:types/:quyu/:page', :controller => "events", :action => "coupon_show", :conditions => { :subdomain => 'z' }
  map.connect '/quotations/:id', :controller => "events", :action => "quotation", :conditions => { :subdomain => 'z' }
  #end--------------------------------------------------------------------
  #add seg
  map.connect '/dianping/newdp/:id', :controller => "dianping", :action => 'newdp', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/editnew/:id', :controller => "dianping", :action => 'editnew', :conditions => { :subdomain => 'z' }
  #map.connect '/dianping-:id', :controller => "dianping", :action => 'shownew'
  map.connect '/dianping/badegg', :controller => "dianping", :action => 'badegg'
  map.connect '/dianping/continuenew/:main_id', :controller => "dianping", :action => 'continuenew', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/continuenew', :controller => "dianping", :action => 'continuenew', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/dianping_list', :controller => "dianping", :action => 'dianping_list', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/dianping_delete/:id', :controller => "dianping", :action => 'dianping_delete', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/addreplynew', :controller => "dianping", :action => 'addreplynew', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/company', :controller => "dianping", :action => 'company', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/select_city_area', :controller => "dianping", :action => 'select_city_area', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/dianping_series/:id', :controller => "dianping", :action => 'dianping_series', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/dianping_series', :controller => "dianping", :action => 'dianping_series', :conditions => { :subdomain => 'z' }
  map.connect '/dianping-:id', :controller => "dianping", :action => 'shownew1'
  map.connect '/dianping/addreplynew1', :controller => "dianping", :action => 'addreplynew1', :conditions => { :subdomain => 'z' }
  #end seg
  map.connect '/dianping/addreply', :controller => "dianping", :action => 'addreply', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/flower', :controller => "dianping", :action => 'flower', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/flower2', :controller => "dianping", :action => 'flower2', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/flower3', :controller => "dianping", :action => 'flower3', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/deletereply', :controller => "dianping", :action => 'deletereply', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/companycomment/:id/:type/:page', :controller => "dianping", :action => 'companycomment', :conditions => { :subdomain => 'z' }
  #  map.connect '/dianping/:page', :controller => "dianping", :action => 'indexnew'
  map.connect '/dianping/:page', :controller => "firms", :action => 'indexnew2', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/:city.:room.:price.:style.:page', :controller => "dianping", :action => 'indexnew', :conditions => { :subdomain => 'z' }
  map.connect '/dianping/:page/:type', :controller => "dianping", :action => 'index', :conditions => { :subdomain => 'z' }
  map.connect '/dianping', :controller => "firms", :action => 'indexnew2', :conditions => { :subdomain => 'z' }
  map.connect '/vedio/:id', :controller => "vedio", :action => 'show', :conditions => { :subdomain => 'z' }
  map.connect '/commonts/show/:id', :controller => "commonts", :action => 'show', :conditions => { :subdomain => 'z' }
  map.connect '/cases/company/:id', :controller => "cases", :action => 'company', :conditions => { :subdomain => 'z' }
  map.connect '/designers/index/:id', :controller => "designers", :action => 'index', :conditions => { :subdomain => 'z' }
  # map.connect '/anli/:id', :controller => "cases", :action => 'zHuangCase'
  map.connect 'zhuangxiuanli/:feiyong.:fengge.:yongtu.:huxing.:page.html', :controller => "cases", :action => 'list', :conditions => { :subdomain => 'z' }
  map.connect 'zhuangxiuanli/:page', :controller => "cases", :action => 'list', :conditions => { :subdomain => 'z' }
  map.connect 'zhuangxiuanli', :controller => "cases", :action => 'list', :conditions => { :subdomain => 'z' }
  map.connect '/anli/:id', :controller => "cases", :action => 'show', :conditions => { :subdomain => 'z' }
  #add seg begin 2009-11-19
  map.connect '/anli/down_case/:case_id', :controller => "cases", :action => 'down_case', :conditions => { :subdomain => 'z' }
  map.connect '/anli/down_case/:case_id/:tag_id', :controller => "cases", :action => 'down_case', :conditions => { :subdomain => 'z' }
  map.connect '/cases/up/:id', :controller => "cases", :action => 'up', :conditions => { :subdomain => 'z' }
  map.connect '/cases/down/:id', :controller => "cases", :action => 'down', :conditions => { :subdomain => 'z' }
  
  #end seg
  #  map.connect '/zhuangxiugongsi', :controller => "firms", :action => 'indexnew'
  #  map.connect '/zhuangxiugongsi/:page', :controller => "firms", :action => 'indexnew'
  
  map.connect '/zhuangxiugongsi', :controller => "firms", :action => 'index', :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiugongsi/:page', :controller => "firms", :action => 'index', :conditions => { :subdomain => 'z' }
  map.connect '/video/:id', :controller => "vedio", :action => 'show', :conditions => { :subdomain => 'z' }
  #E都市
  map.connect '/embed/company/:name', :controller => "embed", :action => 'index', :conditions => { :subdomain => 'z' }

  # firm ajax paginator
  map.connect '/gs-:id/remarks/paginator', :controller => 'remarks', :action => 'paginator', :conditions => { :subdomain => 'z' }
  map.connect '/gs-:id/diaries/paginator', :controller => 'decoration_diaries', :action => 'paginator', :conditions => { :subdomain => 'z' }
  map.connect '/gs-:id/cases/paginator', :controller => 'cases', :action => 'paginator', :conditions => { :subdomain => 'z' }
  map.connect '/gs-:id/photos/paginator', :controller => 'photos', :action => 'paginator', :conditions => { :subdomain => 'z' }
  map.connect '/gs-:id/designers/paginator', :controller => 'designers', :action => 'paginator', :conditions => { :subdomain => 'z' }
  
  map.connect '/gs-:id/cases/', :controller => 'cases',:action => 'company' , :conditions => { :subdomain => 'z' }#公司案例
  map.connect '/gs-:cid/cases-:id/', :controller => 'cases',:action => 'zHuangCase' , :conditions => { :subdomain => 'z' }#公司案例终端
  map.connect '/gs-:firm_id/photos/', :controller => 'photos',:action => 'index' , :conditions => { :subdomain => 'z' }#公司图片
  map.connect '/gs-:firm_id/photos/:page/', :controller => 'photos',:action => 'index' , :conditions => { :subdomain => 'z' }#公司图片加翻页
  map.connect '/gs-:id/promotion/', :controller => 'firms',:action => 'promotion' , :conditions => { :subdomain => 'z' }#公司促消
  map.connect '/gs-:id/designers/', :controller => 'designers',:action => 'show' , :conditions => { :subdomain => 'z' }#公司促消
  map.connect '/gs-:id/designers/:designer_id', :controller => 'designers',:action => 'show' , :conditions => { :subdomain => 'z' }#公司促消
  map.connect '/gs-:cid/dianping/:id', :controller => 'dianping', :action => 'shownew1', :conditions => { :subdomain => 'z' } #点评终端
  map.company_summary '/gs-:id/summary', :controller => 'firms', :action => 'summary', :conditions => {:subdomain => 'z'}
  map.connect '/gs-:cid/y-:id/', :controller => 'events',:action => 'coupon' , :conditions => { :subdomain => 'z' }#公司优惠
  map.connect '/gs-:id/:page', :controller => 'firms', :action => 'show', :conditions => { :subdomain => 'z' }
  map.connect '/gs-:id/', :controller => 'firms', :action => 'show', :conditions => { :subdomain => 'z' }
  map.connect '/test/gs-:id/', :controller => 'firms', :action => 'show', :conditions => { :subdomain => 'z' }

  # 下面两个本来是指向'shownew3'的，但是由于地址已经不再使用，所以指到'show'，而'show'会跳转到正确的地址上
  map.connect '/firms-:id', :controller => "firms", :action => "show", :conditions => { :subdomain => 'z' }
  map.connect '/firms-:id-:page', :controller => "firms", :action => "show" , :conditions => { :subdomain => 'z' }
  #文章列表页
  map.connect '/:first_tag_url/:tag_type-:tag_id.:s', :controller => "article", :action => "list"
  map.connect '/:first_tag_url/:tag_type/:tag_id/:format/:page.:s', :controller => "article", :action => "list"
  map.connect '/:first_tag_url/:tag_type/:tag_id/l/:page.:s', :controller => "article", :action => "list"
  map.connect '/:first_tag_url/articleList/:tag_type-:tag_id', :controller => "article", :action => "list"
  map.connect '/:first_tag_url/articleList/:tag_type/:tag_id/:format/:page', :controller => "article", :action => "list"
  map.connect '/:first_tag_url/articleList/:tag_type/:tag_id/l/:page', :controller => "article", :action => "list"
  map.connect '/:first_tag_url/articleList/:tag_type-:tag_id/:month', :controller => "article", :action => "list"
  map.connect '/:first_tag_url/articleList/:tag_type/:tag_id/:month/:format/:page', :controller => "article", :action => "list"
  map.connect '/:first_tag_url/articleList/:tag_type/:tag_id/:month/l/:page', :controller => "article", :action => "list"
  map.connect '/articleList/:tag_type-:tag_id', :controller => "article", :action => "list"
  map.connect '/articleList/:tag_type/:tag_id/:format/:page', :controller => "article", :action => "list"
  map.connect '/articleList/:tag_type/:tag_id/l/:page', :controller => "article", :action => "list"
  #文章终端页
  map.connect '/:first_tag_url/:create_time/:article_id', :controller => "article", :action => "show"
  map.connect '/:first_tag_url/:create_time/:article_id-:page', :controller => "article", :action => "show"
  map.connect '/:first_tag_url/:second_tag_url/:create_time/:article_id', :controller => "article", :action => "show"
  map.connect '/:first_tag_url/:second_tag_url/:create_time/:article_id-:page', :controller => "article", :action => "show"
  map.connect '/:first_tag_url/:second_tag_url/:third_tag_url/:create_time/:article_id', :controller => "article", :action => "show"
  map.connect '/:first_tag_url/:second_tag_url/:third_tag_url/:create_time/:article_id-:page', :controller => "article", :action => "show"

  map.connect '/zhuangxiugushi', :controller => "note", :action => 'list', :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiugushi/:page', :controller => "note", :action => 'list', :conditions => { :subdomain => 'z' }
  
  #***************日记终端页最新路由*****************************#
  map.connect '/gs-:fid/zhuangxiugushi/:nid', :controller => "decoration_diaries", :action => 'index', :conditions => { :subdomain => 'z' }
  
  #以前日记终端页路由转向到新的路由
  map.connect '/gs-:fid/zhuangxiugushi/:nid/all/:page', :controller => "decoration_diaries", :action => 'turn_to', :conditions => { :subdomain => 'z' }
  map.connect '/gs-:fid/zhuangxiugushi/:nid/all/:page/:pagesize', :controller => "decoration_diaries", :action => 'turn_to', :conditions => { :subdomain => 'z' }
  map.connect '/gs-:fid/zhuangxiugushi/:nid/tag-:type/:page', :controller => "decoration_diaries", :action => 'turn_to', :conditions => { :subdomain => 'z' }
  
  #日记终端页鲜花鸡蛋
  map.connect '/decoration_diaries/flower', :controller => "decoration_diaries", :action => 'flower', :conditions => { :subdomain => 'z' }
  map.connect '/decoration_diaries/egg', :controller => "decoration_diaries", :action => 'egg' ,:conditions => { :subdomain => 'z' }
  map.connect '/decoration_diaries/new_diray_remark' ,:controller => "decoration_diaries" ,:action => 'new_diray_remark' ,:conditions => { :subdomain => 'z' } 
  map.connect '/decoration_diaries/user_login' ,:controller => "decoration_diaries" ,:action => 'user_login' ,:conditions => { :subdomain => 'z' } 
  map.connect '/zhuangxiugushi/:method-:style-:price-:stage-:room-:alltype-:title-:myorder-:dianping', :controller => "note", :action => 'list', :conditions => { :subdomain => 'z' }
  map.connect '/zhuangxiugushi/:method-:style-:price-:stage-:room-:alltype-:title-:myorder-:dianping-:page', :controller => "note", :action => 'list', :conditions => { :subdomain => 'z' }
  
  ## 模拟点击路由
  map.connect 'analog_codes', :controller => 'analog_codes', :action => 'index', :conditions => { :subdomain => 'api' }
  map.connect 'analog_codes/create_analog_url', :controller => "analog_codes", :action => "create_analog_url", :conditions => { :subdomain => 'api' }

  map.connect 'statistics', :controller => 'statistics', :action => 'index', :conditions => { :subdomain => 'api' }


  # engines插件提供的路由
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end

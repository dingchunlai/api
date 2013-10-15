require_dependency "#{RAILS_ROOT}/app/models/publish_content"
require "active_support"
include ActiveSupport
class AdminController < ApplicationController
  before_filter :user_validate #验证用户身份
  after_filter :store_url_from, :only => ["show_group", "login", "publish_list", "before_publish_list", "search_column", "search_article_or_case"]
  def login
    @editor_id = current_staff.id
    session[:editor_id] = @editor_id
    @pages, @groups = paginate(:publish_column_groups,
      :conditions => ["editor_id = ? and is_del = ?", @editor_id, false],
      :per_page => 15)

    @public_groups = PublishColumnGroup.find(:all,
      :conditions => ["public_ids like ? and is_del = ?", "%#{@editor_id}%", false])
    @total = @pages.item_count + @public_groups.size
  end

  #----------------------group----------------------

  def save_group
    group = PublishColumnGroup.new(params[:group])
    if group.save
      redirect_to session[:url_from]
    else
      redirect_to session[:url_from]
    end
  end
  
  def edit_group
    @group = PublishColumnGroup.find(params[:group_id])
  end

  def update_group
    PublishColumnGroup.update(params[:group_id], params[:group])
    flash[:msg] = "编辑成功"
    redirect_to session[:url_from]
  end

  def destory_group
    PublishColumnGroup.update(params[:group_id], :is_del => true)
    flash[:msg] = "删除成功"
    redirect_to session[:url_from]
  end
  
  def show_group
    @group_id = params[:group_id]
    @pages, @results = paginate(:publish_columns,
      :conditions => ["group_id = ? and is_del = ?", params[:group_id], false],
      :per_page => 15)
    @total = @pages.item_count
  end

  def share_group
    @group = PublishColumnGroup.find(params[:group_id])
    sql = "select id as editor_id, rname as name from radmin_users where (state is null or state <> 1) and role like '%151%'"
    #sql = "select distinct(g.editor_id) as editor_id, u.rname as name from publish_column_groups g, radmin_users u where g.editor_id = u.id and (u.state is null or u.state <> 1) and g.editor_id != #{session[:editor_id]}"
    @results = PublishColumnGroup.find_by_sql sql 
  end

  def assign_group
    ids = params[:public_ids]
    unless ids.blank?
      public_ids = ids.join(",")
    else
      public_ids = ""
    end
    PublishColumnGroup.update(params[:group_id], :public_ids => public_ids)
    redirect_to session[:url_from]
  end

  #----------------------column----------------------

  def save_column
    column = PublishColumn.new(params[:column])
    if column.save
      build_xml_file(column.id)
      flash[:msg] = "添加成功"
      redirect_to session[:url_from]
    end
  end

  def edit_column
    @column = PublishColumn.find(params[:column_id])
  end

  def update_column
    PublishColumn.update(params[:column_id], params[:column])
    flash[:msg] = "编辑成功"
    redirect_to session[:url_from]
  end

  def destory_column
    PublishColumn.update(params[:column_id], :is_del => true)
    flash[:msg] = "删除成功"
    redirect_to session[:url_from]
  end

  #----------------------content----------------------

  def save_content
    content = PublishContent.new(params[:content])
    if params[:publish_upload] && params[:publish_upload][:uploaded_data].to_s != ''
      @upload = PublishUpload.new(params[:publish_upload])
      if @upload.save
        filename = @upload.public_filename()
        content.image_url = filename
      end
    end
    content.is_valid = 1
    content.save
    flash[:msg] = "添加成功，为预发布文章。"
    update_xml_cache(params[:column_id])
    redirect_to session[:url_from]
  end

  def edit_content
    @publish_content = PublishContent.find(params[:content_id])
    if @publish_content.publish_content_keywords.blank?
      @pcks = [PublishContentKeyword.new(),PublishContentKeyword.new(),PublishContentKeyword.new(),PublishContentKeyword.new(),PublishContentKeyword.new()]
    else
      @pcks = @publish_content.publish_content_keywords
      (5 - @publish_content.publish_content_keywords.size).times do
        @pcks << PublishContentKeyword.new()
      end
    end
  end

  def update_content
    content = PublishContent.update(params[:content_id], params[:publish_content])
    if params[:publish_upload][:uploaded_data].to_s != ''
      @upload = PublishUpload.new(params[:publish_upload])
      if @upload.save
        filename = @upload.public_filename()
        content.image_url = filename
      end
    end
    unless params[:publish_content_keyword].blank?
      params[:publish_content_keyword].each do |pck|
        unless pck[1].values_at("id")[0].blank?
          @pck = PublishContentKeyword.find(pck[1].values_at("id")[0].to_i)
          @pck.attributes = pck[1]
          @pck.save if @pck.valid?
        else
          @pck = PublishContentKeyword.new(pck[1])
          @pck.publish_content_id = params[:content_id]
          @pck.save if @pck.valid?
        end
      end
    end
    
    content.save
    flash[:msg] = "编辑成功"
    update_xml_cache(params[:column_id])
    redirect_to session[:url_from]
  end

  def destory_content
    PublishContent.update(params[:content_id], :is_del => true )
    flash[:msg] = "删除成功"
    update_xml_cache(params[:column_id])
    redirect_to session[:url_from]
  end

  def batch_destory_content
    params[:batch_publish].each do |id|
      PublishContent.update(id, :is_del => true )
    end
    flash[:msg] = "删除成功"
    update_xml_cache(params[:column_id])
    redirect_to session[:url_from]
  end

  #预发布列表
  def before_publish_list
    @column_id = params[:column_id]
    @pages, @results = paginate(:publish_contents,
      :conditions => ["publish_column_id = ? and is_valid = ? and is_del = ?", @column_id, 1, false],
      :per_page => 15, :order => "order_id DESC, entity_created_at DESC")
    @total = @pages.item_count
  end

  #发布列表
  def publish_list
    @column_id = params[:column_id]
    @pages, @results = paginate(:publish_contents,
      :conditions => ["publish_column_id = ? and is_valid = ? and is_del = ?", @column_id, 2, false],
      :per_page => 15, :order => "order_id DESC, entity_created_at DESC")
    @total = @pages.item_count
  end

  #发布或取消发布
  def publish
    if params[:method] == "p"
      PublishContent.update(params[:content_id], :is_valid => 2)
      flash[:msg] = "发布成功"
    elsif params[:method] == "c"
      PublishContent.update(params[:content_id], :is_valid => 1)
      flash[:msg] = "取消成功"
    end
    update_xml_cache(params[:column_id])
    redirect_to session[:url_from]
  end

  ## 发布列表数据导出
  def expert_publish_contents
    @column_id = params[:column_id]
    @publish_contents = PublishContent.find(:all,:conditions => ["publish_column_id = ? and is_valid = ? and is_del = ?", @column_id, 2, false])

    e = Excel::Workbook.new
    sheetname = PublishColumn.find(@column_id).name
    unless @publish_contents
      flash[:notice] = "没有符合条件的友情链接！"
      redirect_to "/common/export"
    else
      array = Array.new
      @publish_contents.each do |pc|
        item = Hash.new
        item["编号"] = pc.id
        item["标题"] = pc.title
        item["网址"] = pc.url
        array << item
      end
      e.addWorksheetFromArrayOfHashes(sheetname, array)
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Type'] = "application/vnd.ms-excel;charset=GBK"
      headers['Content-Disposition'] = "attachment; filename=#{PublishColumn.find(@column_id).name}.xls"
      render :text => e.build
    end
  end

  #批量发布或批量取消发布
  def batch_publish
    for id in params[:batch_publish]
      if params[:method] == "p"
        PublishContent.update(id, :is_valid => 2)
        flash[:msg] = "发布成功"
      elsif params[:method] == "c"
        PublishContent.update(id, :is_valid => 1)
        flash[:msg] = "取消成功"
      end
    end
    update_xml_cache(params[:column_id])
    redirect_to session[:url_from]
  end

  #----------------------search----------------------

  def search_column
    @keyword = params[:keyword]
    if request.post?
      redirect_to :action => "search_column", :keyword => @keyword
    else
      groups = PublishColumnGroup.find(:all,
        :conditions => ["(editor_id = #{session[:editor_id]} or public_ids like ? ) and is_del = #{false}", "%#{session[:editor_id]}%"])
      group_ids_array = []
      groups.each { |g| group_ids_array << g.id }
      group_ids_string = group_ids_array.join(",")
      @pages, @results = paginate(:publish_columns,
        :conditions => ["group_id in (#{group_ids_string}) and is_del = #{false} and name like ?", "%#{@keyword}%"],
        :per_page => 15)
      @total = @pages.item_count
      render :template => "admin/show_group"
    end
  end

  def search_article_or_case
    @keyword = params[:keyword]
    @start_time = params[:start_time]
    @end_time = params[:end_time]
    @search_type = params[:search_type]
    if request.post?
      redirect_to :action => "search_article_or_case", :keyword => @keyword, :start_time => @start_time,
        :end_time => @end_time, :search_type => @search_type
    else
      if @search_type == "0"
        @pages, @results = paginate(:hejia_case,
          :conditions => ["NAME like ? and STATUS != -100 and CREATEDATE > '#{@start_time}' and CREATEDATE < '#{@end_time}' and (TYPE_ID is null or ISGOOD = 1)", "%#{@keyword}%"],
          :order => "CREATEDATE DESC", :per_page => 15)
        @total = @pages.item_count
        flash[:msg] = "搜索成功" if params[:page].nil?
        render :template => "admin/search_case"
      else
        @pages, @results = paginate(:hejia_article,
          :conditions => ["FIRSTCATEGORY = ? and TITLE like '%#{@keyword}%' and CREATETIME > '#{@start_time}' and CREATETIME < '#{@end_time}'", @search_type],
          :order => "CREATETIME DESC", :per_page => 15)
        @total = @pages.item_count
        flash[:msg] = "搜索成功" if params[:page].nil?
        render :template => "admin/search_article"
      end
    end
  end

  def publish_article
    params[:publish_index].each do |id|
      result = HejiaArticle.find(:first, :conditions => ["ID = ?", id])
      url, image_url = get_article_url_image_url(result.ID, result.FIRSTCATEGORY, result.CREATETIME, result.IMAGENAME)
      time = Time.now
      PublishContent.create(:title => result.TITLE, :description => result.SUMMARY, :entity_id => result.ID,
        :publish_time => time, :entity_type_id => 1, :url => url, :image_url => image_url, :is_valid => 1,
        :entity_created_at => result.CREATETIME, :entity_updated_at => time, :publish_column_id => params[:column_id])
    end
    flash[:msg] = "预发布成功"
    update_xml_cache(params[:column_id])
    redirect_to session[:url_from]
  end
  
  def publish_case
    params[:publish_index].each do |id|
      result = HejiaCase.find(:first, :conditions => ["ID = ?", id])
      url = "http://tuku.51hejia.com/zhuangxiu/tuku-#{result.ID}"
      image_url = result.TYPE_ID == 5 ? "http://image.51hejia.com#{result.MAINPHOTO}" : "http://image.51hejia.com/files/hekea/case_img/tn/#{id}.jpg"
      time = Time.now
      PublishContent.create(:title => result.NAME, :description => result.INTRODUCE, :entity_id => result.ID,
        :publish_time => time, :entity_type_id => 4, :url => url, :image_url => image_url, :is_valid => 1,
        :entity_created_at => result.CREATEDATE, :entity_updated_at => time, :publish_column_id => params[:column_id])
    end
    flash[:msg] = "预发布成功"
    update_xml_cache(params[:column_id])
    redirect_to session[:url_from]
  end

  def create_xml
    build_xml_file(params[:id])
    CACHE.set("key_publish_article_right_column_#{params[:id]}", nil)
    render :text => "OK"
  end

  private
  def update_xml_cache(column_id)
    build_xml_file(column_id)
    CACHE.set("key_publish_article_right_column_#{column_id}", nil)
  end

end

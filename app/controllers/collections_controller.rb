class CollectionsController < ApplicationController
  #添加到收藏
  def add
    params[:obj_id]
    params[:obj_type]
    params[:obj_name]
    params[:photo_url]
    params[:url]
    if user_logged_in?
      if params[:obj_type].to_i != 0
        t = UserCollection.find(:first,:conditions => "obj_type = '#{params[:obj_type]}' and obj_id = '#{params[:obj_id]}'")
      else
        t = UserCollection.find(:first,:conditions => "obj_type = '#{params[:obj_type]}' and url = '#{params[:url]}'")
      end
      if t && t.id
      else
        collection = UserCollection.new
        collection.obj_id = params[:obj_id]
        collection.obj_type = params[:obj_type].to_i
        collection.obj_name = params[:obj_name]
        collection.photo_url = params[:photo_url]
        collection.url = params[:url]
        collection.status = 1
        collection.user_id = current_user.USERBBSID
        collection.created_at = Time.now
        collection.updated_at = Time.now
        collection.save
      end
      render :text => "<script type=\"text/javascript\">alert('收藏成功')</script>"   
    else
      render :text => "<script type=\"text/javascript\">alert('请先登陆')</script>"   
    end
    
#    render :nothing => true
    
  end
end

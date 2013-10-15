function editor_link_about_article(){
    var editor_ids = new Array(7134345)
    if(is_valid(editor_ids, getCookie("ind_id"))){
        document.getElementById('xgwz').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=33' style='color:#FF0000;' target='_blank'>相关文章后台链接</a>";
        document.getElementById('hw').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=34' style='color:#FF0000;' target='_blank'>海外后台链接</a>";
        document.getElementById('jjht').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=35' style='color:#FF0000;' target='_blank'>家居话题后台链接</a>";
    }
}
function editor_link_product_pricing(){
    var editor_ids = new Array(7134345)
    if(is_valid(editor_ids, getCookie("ind_id"))){
        document.getElementById('jcdg').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=46' style='color:#FF0000;' target='_blank'>建材导购后台链接</a>";
        document.getElementById('bjtj').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=47' style='color:#FF0000;' target='_blank'>编辑推荐后台链接</a>";
        document.getElementById('zxdh').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=48' style='color:#FF0000;' target='_blank'>装修导航后台链接</a>";
        document.getElementById('jcmt').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=49' style='color:#FF0000;' target='_blank'>精彩美图后台链接</a>";
    }
}
function editor_link_service_navigation_bar(){
    var editor_ids = new Array(7134345)
    if(is_valid(editor_ids, getCookie("ind_id"))){
        document.getElementById('jczt').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=37' style='color:#FF0000;' target='_blank'>精彩专题后台链接</a>";
        document.getElementById('xwphb').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=38' style='color:#FF0000;' target='_blank'>新闻排行榜后台链接</a>";
        document.getElementById('wzs').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=39' style='color:#FF0000;' target='_blank'>问知识后台链接</a>";
        document.getElementById('zgs').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=40' style='color:#FF0000;' target='_blank'>找公司后台链接</a>";
        document.getElementById('mcp').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=41' style='color:#FF0000;' target='_blank'>买产品后台链接</a>";
        document.getElementById('tsb').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=40' style='color:#FF0000;' target='_blank'>添设备后台链接</a>";
        document.getElementById('zxcprxb').innerHTML = "<a href='http://api.51hejia.com/admin/publish_list?column_id=40' style='color:#FF0000;' target='_blank'>后台链接</a>";
    }
}
function getCookie(c_name){
    if (document.cookie.length>0){
        c_start=document.cookie.indexOf(c_name + "=")
        if (c_start!=-1){
            c_start=c_start + c_name.length+1
            c_end=document.cookie.indexOf(";",c_start)
            if (c_end==-1) c_end=document.cookie.length
            return decodeURI(document.cookie.substring(c_start,c_end))
        }
    }
    return null
}
function is_valid(array, id){
    if(id != null){
        for(var i = 0; i < array.length; i++){
            if(array[i] == id){
                return true;
                break;
            }
        }
        return false;
    }
    return false;
}
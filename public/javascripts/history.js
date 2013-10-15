function Cookie(document, name, hours, path, domain, secure)
{
    this.$document = document;
    this.$name = name;
    if (hours)
        this.$expiration = new Date((new Date()).getTime() + hours*3600000);
    else this.$expiration = null;
    if (path) this.$path = path; else this.$path = null;
    if (domain) this.$domain = domain; else this.$domain = null;
    if (secure) this.$secure = true; else this.$secure = false;
}

function _Cookie_store()
{
    var cookie = this.$name + '=' + this.$value;
    if (this.$expiration)
        cookie += '; expires=' + this.$expiration.toGMTString();
    if (this.$path) cookie += '; path=' + this.$path;
    if (this.$domain) cookie += '; domain=' + this.$domain;
    if (this.$secure) cookie += '; secure';
    this.$document.cookie = cookie;
}

function _Cookie_remove()
{
    var cookie;
    cookie = this.$name + '=';
    if (this.$path) cookie += '; path=' + this.$path;
    if (this.$domain) cookie += '; domain=' + this.$domain;
    cookie += '; expires=Fri, 02-Jan-1970 00:00:00 GMT';
    this.$document.cookie = cookie;
}

function _Cookie_load()
{
    var allcookies = this.$document.cookie;
    if (allcookies == "") return false;

    var start = allcookies.indexOf(this.$name + '=');
    if (start == -1) return false;   
    start += this.$name.length + 1;  
    var end = allcookies.indexOf(';', start);
    if (end == -1) end = allcookies.length;
    var cookieval = allcookies.substring(start, end);
    this.$value = cookieval;
    return true;
}

new Cookie();
Cookie.prototype.store = _Cookie_store;
Cookie.prototype.load = _Cookie_load;
Cookie.prototype.remove = _Cookie_remove;

function Set_Cookie(name, value){
	value = escape(value);
	var visitordata = new Cookie(document, name, 10000,'/');
	if (!visitordata.load()) {
    		visitordata.$value = '+' + value;
	}else{
		visitordata.$value = visitordata.$value + '+' + value;		
	}
	visitordata.store();

}

function Get_Cookie(name){
	var visitordata = new Cookie(document, name, 10000,'/');
	if(visitordata.load()){
		return unescape(visitordata.$value);
	}else{
		return "";
	}
}

function Del_Cookie(name, value){
	value = escape(value);
	var visitordata = new Cookie(document, name, 10000,'/');
	if(visitordata.load()){
		visitordata.$value = (visitordata.$value).replace('+'+value,'');
		visitordata.store();
	}
	return true;	
}


function loadAllProByCookie(){
	if(Get_Cookie('proId') != null && Get_Cookie('proId') != ''){
		var ids = Get_Cookie('proId').split('+');
		var images = Get_Cookie('proImage').split('+');
		var names = Get_Cookie('proName').split('+');
		var types = Get_Cookie('proType').split('+');
		var pro_list = new Array();
		for(var i=1;i<ids.length;i++){
			var obj = new Object();
			obj.id = ids[i];
			obj.image = images[i];
			obj.name = names[i];
			obj.type = types[i];
			pro_list.push(obj);
		}
		return pro_list;
	}
	return new Array();
}

function createHtml() {	
	var pro_list=loadAllProByCookie();
	if(pro_list.length>0){
		var str = '';
	
		for(var i=0;i<pro_list.length&&i<5;i++){
			str += "<li><a href='/firms/"+pro_list[i].id+"' target='_blank'>"+pro_list[i].name+"</a></li>";
		}
		document.getElementById('browser_history').innerHTML = str;
	}	
}

function Del_AllCookies(id,image,name,type){
	Del_Cookie('proId',id);
	Del_Cookie('proImage',image);
	Del_Cookie('proName',name);	
	Del_Cookie('proType',type);	
}

function save_Pro(id,image,name,type){
	var pro_list=loadAllProByCookie();
	if(pro_list.length>0){
		for(var i=0;i<pro_list.length;i++){
			if(pro_list[i].id == id)
				return;
		}
	}
	if(pro_list.length>4){
		Del_AllCookies(pro_list[0].id,pro_list[0].image,pro_list[0].name,pro_list[0].type);
	}
	Set_Cookie('proId',id);
	Set_Cookie('proImage',image);
	Set_Cookie('proName',name);
	Set_Cookie('proType',type);
}
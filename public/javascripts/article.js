function ContentSize(size,id)
{
	var obj=document.getElementById(id);
	obj.style.fontSize=size+"px";
}
function shoucang(type,typeId,readme)
	{
		document.getElementById("shoucang").submit();
	}
    function CText(){
    	var copy=window.location.href;
        clipboardData.setData('text',copy);
        alert('网址已复制，粘贴给好友请按Crtl+V。');
    }
    function init_Nav()
{

	var nav1 = ycn.Common.getEl('Nav1');
	var navMenu1 = ycn.Common.getEl('Nav1Menu');

	ycn.Event.addEvent(nav1,'click',disMenu);
	ycn.Event.addEvent(navMenu1,'mouseover',disMenu);

	ycn.Event.addEvent(nav1,'mouseout',hidMenu);
	ycn.Event.addEvent(navMenu1,'mouseout',hidMenu);
}


function disMenu(evt)
{
	if(ycn.Common.isIE()){var el=window.event.srcElement;}else{var el=evt.target;}
	while(el.id == "")
	{
		el = el.parentNode
	}
	
	var navMenu = ycn.Common.getEl(el.id.substring(0,4) + "Menu");
	navMenu.style.visibility="visible";
}

function hidMenu(evt)
{
	if(ycn.Common.isIE()){var el=window.event.srcElement;}else{var el=evt.target;}
	while(el.id == "")
	{
		el = el.parentNode
	}

	var navMenu = ycn.Common.getEl(el.id.substring(0,4) + "Menu");
	navMenu.style.visibility="hidden";
}






function SetCookie() {
	var cookieValue="it168";
	var cookieName="it168tag";
	var today = new Date();
	var expire = new Date();
	expire.setTime(today.getTime() + 3600000*24*1); 
	document.cookie = cookieName+"="+escape(cookieValue) + ";path=/;domain=.it168.com;expires="+expire.toGMTString();
}

SetCookie();
ycn=window.ycnui||{};
ycn.Common=new function(){
	this.lTrim=function(i){return i.replace(/^\s*/,"");};
	this.rTrim=function(i){return i.replace(/\s*$/,"");};
	this.trim=function(i){return this.rTrim(this.lTrim(i));};
	this.getEl=function(i)
	{
		if(!document.getElementById)return false;
		if(typeof i==="string")
		{
			return document.getElementById(i);
		}
		else
		{
			return i;
		}
	};
	this.getElByClassName=function(t,n,s,el)
	{
		var el=(el)?el:document;
		var itm=el.getElementsByTagName(t);
		var num=1;
		for(i=0;i<itm.length;i++)
		{
			if(itm[i].className===n&&s===num)
			{
				return itm[i];
			}
			else if(itm[i].className===n)
			{
				num++;
			}
		}
		return false;
	};
	this.isIE6=function()
	{
		return navigator.userAgent.search('MSIE')>0&&navigator.userAgent.search('6')>0;
	}
	this.isIE=function()
	{
		return navigator.userAgent.search('MSIE')>0;
	}
	this.isOpera=function()
	{
		return navigator.userAgent.indexOf('Opera')>-1;
	}
	this.isMoz=function()
	{
		return navigator.userAgent.indexOf('Mozilla/5.')>-1;
	}
	this.setCookie=function(cn,cv,d,dm)
	{
		var now=new Date();
		var expire=new Date();
		if(d==null||d==0)d=1;
		expire.setTime(now.getTime()+3600000*24*d);
		document.cookie=cn+"="+escape(cv)+";expires="+expire.toGMTString()+";domain="+dm;
	}
	this.deleteCookie=function(cn,dm)
	{
		if(getCookie(cn))
		{
			document.cookie=cn+"="+((domain)?"; domain="+dm:"")+"; expires=Thu,01-Jan-70 00:00:01 GMT";
		}
	}
	this.getCookie=function(cn)
	{
		var dc=document.cookie;
		var prefix=cn+"=";
		var begin=dc.indexOf("; "+prefix);
		if(begin==-1)
		{
			begin=dc.indexOf(prefix);
			if(begin!=0)return null;
		}
		else
		{
			begin+=2;
		}
		var end=document.cookie.indexOf(";",begin);
		if(end==-1)
		{
			end=dc.length;
		}
		return unescape(dc.substring(begin+prefix.length,end));
	}
};

ycn=window.ycn||{};ycn.Event={addEvent:function(obj,evType,fn){if(obj.addEventListener)
{obj.addEventListener(evType,fn,false);return true;}
else if(obj.attachEvent)
{var r=obj.attachEvent("on"+evType,fn);ycn.EventCache.add(obj,evType,fn);return r;}
else
{return false;}},removeEvent:function(obj,evType,fn){if(obj.removeEventListener){obj.removeEventListener(evType,fn,false);return true;}else if(obj.detachEvent){var r=obj.detachEvent("on"+evType,fn);return r;}else{return false;}},getEvent:function(e)
{e=window.event||e;e.leftButton=false;if(e.srcElement==null&&e.target!=null)
{e.srcElement=e.target;e.leftButton=(e.button==1);}
else if(e.target==null&&e.srcElement!=null)
{e.target=e.srcElement;e.leftButton=(e.button==0);}
else if(e.srcElement!=null&&e.target!=null)
{}
else{return null}
if(document.body&&document.documentElement)
{e.mouseX=e.pageX||(e.clientX+Math.max(document.body.scrollLeft,document.documentElement.scrollLeft));e.mouseY=e.pageY||(e.clientY+Math.max(document.body.scrollTop,document.documentElement.scrollTop));}
else
{e.mouseX=-1;e.mouseY=-1;}
return e;},stopEvent:function(e)
{if(e&&e.cancelBubble!=null)
{e.cancelBubble=true;e.returnValue=false;}
if(e&&e.stopPropagation&&e.preventDefault)
{e.stopPropagation();e.preventDefault();}
return false;}};ycn.EventCache=function()
{var listEvents=[];return{listEvents:listEvents,add:function(node,sEventName,fHandler,bCapture){listEvents[listEvents.length]=arguments;},flush:function(){var i,item;for(i=listEvents.length-1;i>=0;i=i-1)
{item=listEvents[i];if(item[0].removeEventListener){item[0].removeEventListener(item[1],item[2],item[3]);};if(item[1].substring(0,2)!="on"){item[1]="on"+item[1];};if(item[0].detachEvent){item[0].detachEvent(item[1],item[2]);};item[0][item[1]]=null;};}};}();ycn.Event.addEvent(window,"unload",ycn.EventCache.flush);function error_handler(a,b,c)
{window.status=(c+"\n"+b+"\n\n"+a+"\n\n"+error_handler.caller);return true;}
// JavaScript Document
<!--
function stat(base,entityId,entityType,entityUrl){
	var token = base+"/go/stat";
	if(entityId != null && entityId != ""){
		token +="/entityId/"+entityId+'/entityType/'+entityType;
	}
	if(entityUrl != null && entityUrl != ""){
		token +='/entityUrl/'+entityUrl;
	}
	//alert(token);
	document.write("<img src="+token+" />");
}
//-->
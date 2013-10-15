// JavaScript Document

/*
RotatorAD V3.0
Author: Dakular <shuhu@staff.sina.com.cn>
格式: new RotatorAD(商业广告数组, 非商业广告数组, 层id)
说明: 第一次访问随机出现，以后访问顺序轮播；自动过滤过期广告；cookie时间24小时；商业广告数量不足时，从非商业广告中补充
*/
if(typeof(RotatorAD)!='function'){
var RotatorAD = function(rad,nad,div_id){

var date = new Date();
var id = 0;
var max = 99;
var url = document.location.href;
var cookiename = 'sinaRotator'+escape(url.substr(url.indexOf('/',7),2));
var timeout = 1440; //24h
var w = rad.width;
var h = rad.height;
var num = rad.num;
var ary = new Array();
//过滤无效广告
for(var i=0; i<rad.length; i++){
	var start = strToDate(rad[i][2].replace('<startdate>','').replace('</startdate>',''));
	var end = strToDate(rad[i][3].replace('<enddate>','').replace('</enddate>',''),true);
	if(date>start && date<end){
		ary.push([rad[i][0], rad[i][1], rad[i][4], rad[i][5]?rad[i][5]:'0']);
	}
}
//补位
var nn = 0;
if(nad.length>0){
	for(var i=0; i<rad.num; i++){
		if(i>ary.length-1){
			ary.push([nad[nn][0], nad[nn][1], '', '0']);
			if(++nn > nad.length-1) nn = 0;
		}
	}
}else{
	num = ary.length;
}
//排序(同步有序号的广告)
ary.sort(function(x,y){return x[3]-y[3];});
//取id
if(typeof(globalRotatorId)=='undefined' || globalRotatorId==null || isNaN(globalRotatorId)){
	curId = G(cookiename);
	curId = curId==''?Math.floor(Math.random()*max):++curId;
	if(curId>max || curId==null || isNaN(curId)) curId=0;
	S(cookiename,curId,timeout);
	globalRotatorId = curId;
}
id=globalRotatorId%num+1;
//Show AD
if(id==0 || ary.length==0) return; //如果没有广告则不显示
if(id==-1) id=1; //当只有一个广告时：始终显示第一个
var n = id-1;
var type = ary[n][0].substring(ary[n][0].length-3).toLowerCase();
var od = document.getElementById(div_id);
if(type=='swf'){
	var of = new sinaFlash(ary[n][0], div_id+'_swf', w, h, "7", "", false, "High");
	of.addParam("wmode", "opaque");
	of.addVariable("adlink", escape(ary[n][1]));
	of.write(div_id);
}else if(type=='jpg' || type=='gif'){
	od.innerHTML = '<a href="'+ary[n][1]+'" target="_blank"><img src="'+ary[n][0]+'" border="0" width="'+w+'" height="'+h+'" /></a>';
}else if(type=='htm' || type=='tml'){
	od.innerHTML = '<iframe id="ifm_'+div_id+'" frameborder="0" scrolling="no" width="'+w+'" height="'+h+'"></iframe>';
	document.getElementById('ifm_'+div_id).src = ary[n][0];
}else if(type=='.js'){ //js
	document.write('<script language="javascript" type="text/javascript" src="'+ary[n][0]+'"></scr'+'ipt>');
}else{ //textlink
	document.write('<a href="'+ary[n][1]+'"  target="_blank">'+ary[n][0]+'</a>');
}
if(ary[n][2]!="" && ary[n][2]!=null){ //ad tracker
	var oImg = new Image();
	oImg.src = ary[n][2];
}
function G(N){
	var c=document.cookie.split("; ");
	for(var i=0;i<c.length;i++){
		var d=c[i].split("=");
		if(d[0]==N)return unescape(d[1]);
	}return '';
};
function S(N,V,Q){
	var L=new Date();
	var z=new Date(L.getTime()+Q*60000);
	var d = document.domain!=""?("domain="+document.domain+";"):"";
	document.cookie=N+"="+escape(V)+";path=/;"+d+"expires="+z.toGMTString()+";";
};
function strToDate(str,ext){
	var arys = new Array();
	arys = str.split('-');
	var newDate = new Date(arys[0],arys[1]-1,arys[2],9,0,0);
	if(ext){
		newDate = new Date(newDate.getTime()+1000*60*60*24);
	}
	return newDate;
}

}
}

/**
 * sina flash class
 * @version 1.1.4.2
 * @author [sina ui]zhangping1@
 * @update 2008-7-7 
 */
 
if(typeof(sina)!="object"){var sina={}}
sina.$=function(i){if(!i){return null}
return document.getElementById(i)};var sinaFlash=function(V,x,X,Z,v,z,i,c,I,l,o){var w=this;if(!document.createElement||!document.getElementById){return}
w.id=x?x:'';var O=function(I,i){for(var l=0;l<I.length;l++){if(I[l]==i){return l}}
return-1},C='8.0.42.0';if(O(['eladies.sina.com.cn','ent.sina.com.cn'],document.domain)>-1){w.ver=C}else{w.ver=v?v:C}
w.ver=w.ver.replace(/\./g,',');w.__classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000";w.__codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version="+w.ver;w.width=X;w.height=Z;w.movie=V;w.src=w.movie;w.bgcolor=z?z:'';w.quality=c?c:"high";w.__pluginspage="http://www.macromedia.com/go/getflashplayer";w.__type="application/x-shockwave-flash";w.useExpressInstall=(typeof(i)=="boolean")?i:false;w.xir=I?I:window.location;w.redirectUrl=l?l:window.location;w.detectKey=(typeof(o)=="boolean")?o:true;w.escapeIs=false;w.__objAttrs={};w.__params={};w.__embedAttrs={};w.__flashVars=[];w.__flashVarsStr="";w.__forSetAttribute("id",w.id);w.__objAttrs["classid"]=w.__classid;w.__forSetAttribute("codebase",w.__codebase);w.__forSetAttribute("width",w.width);w.__forSetAttribute("height",w.height);w.__forSetAttribute("movie",w.movie);w.__forSetAttribute("quality",w.quality);w.__forSetAttribute("pluginspage",w.__pluginspage);w.__forSetAttribute("type",w.__type);w.__forSetAttribute("bgcolor",w.bgcolor)}
sinaFlash.prototype={getFlashHtml:function(){var I=this,i='<object ';for(var l in I.__objAttrs){i+=l+'="'+I.__objAttrs[l]+'"'+' '}
i+='>\n';for(var l in I.__params){i+='	<param name="'+l+'" value="'+I.__params[l]+'" \/>\n'}
if(I.__flashVarsStr!=""){i+='	<param name="flashvars" value="'+I.__flashVarsStr+'" \/>\n'}
i+='	<embed ';for(var l in I.__embedAttrs){i+=l+'="'+I.__embedAttrs[l]+'"'+' '}
i+='><\/embed>\n<\/object>';return i},__forSetAttribute:function(I,i){var l=this;if(typeof(I)=="undefined"||I==''||typeof(i)=="undefined"||i==''){return}
I=I.toLowerCase();switch(I){case "classid":break;case "pluginspage":l.__embedAttrs[I]=i;break;case "onafterupdate":case "onbeforeupdate":case "onblur":case "oncellchange":case "onclick":case "ondblClick":case "ondrag":case "ondragend":case "ondragenter":case "ondragleave":case "ondragover":case "ondrop":case "onfinish":case "onfocus":case "onhelp":case "onmousedown":case "onmouseup":case "onmouseover":case "onmousemove":case "onmouseout":case "onkeypress":case "onkeydown":case "onkeyup":case "onload":case "onlosecapture":case "onpropertychange":case "onreadystatechange":case "onrowsdelete":case "onrowenter":case "onrowexit":case "onrowsinserted":case "onstart":case "onscroll":case "onbeforeeditfocus":case "onactivate":case "onbeforedeactivate":case "ondeactivate":case "codebase":l.__objAttrs[I]=i;break;case "src":case "movie":l.__embedAttrs["src"]=i;l.__params["movie"]=i;break;case "width":case "height":case "align":case "vspace":case "hspace":case "title":case "class":case "name":case "id":case "accesskey":case "tabindex":case "type":l.__objAttrs[I]=l.__embedAttrs[I]=i;break;default:l.__params[I]=l.__embedAttrs[I]=i}},__forGetAttribute:function(i){var I=this;i=i.toLowerCase();if(typeof I.__objAttrs[i]!="undefined"){return I.__objAttrs[i]}else if(typeof I.__params[i]!="undefined"){return I.__params[i]}else if(typeof I.__embedAttrs[i]!="undefined"){return I.__embedAttrs[i]}else{return null}},setAttribute:function(I,i){this.__forSetAttribute(I,i)},getAttribute:function(i){return this.__forGetAttribute(i)},addVariable:function(I,i){var l=this;if(l.escapeIs){I=escape(I);i=escape(i)}
if(l.__flashVarsStr==""){l.__flashVarsStr=I+"="+i}else{l.__flashVarsStr+="&"+I+"="+i}
l.__embedAttrs["FlashVars"]=l.__flashVarsStr},getVariable:function(I){var o=this,i=o.__flashVarsStr;if(o.escapeIs){I=escape(I)}
var l=new RegExp(I+"=([^\\&]*)(\\&?)","i").exec(i);if(o.escapeIs){return unescape(RegExp.$1)}
return RegExp.$1},addParam:function(I,i){this.__forSetAttribute(I,i)},getParam:function(i){return this.__forGetAttribute(i)},write:function(i){var I=this;if(typeof i=="string"){document.getElementById(i).innerHTML=I.getFlashHtml()}else if(typeof i=="object"){i.innerHTML=I.getFlashHtml()}}}


/*Rotator结束*/


/*ad浮动层*/
function documentWrite(innerH)
{
	document.write(innerH);
}
/*ad浮动层结束*/


/*google广告统计*/

//标准广告统计函数
function googleAdStat(path)
{
	_uacct = "UA-649153-1";
	_udn="51hejia.com";
	_uOsr[34]="soso"; _uOkw[34]="w";
	_uOsr[35]="sogou"; _uOkw[35]="query";
	_uOsr[36]="so.163"; _uOkw[36]="q";
	_uOsr[37]="image.baidu"; _uOkw[37]="word";
	urchinTracker(path);	
}

    /* 
     *@param ifrname: 所需iframe的id
     *@param adUrl: 广告对应的url连接
     *@param path: google统计所需的名称          
     *@param num:该函数动作执行的概率num分之一
     */
    
function flushAds(ifrname,adUrl,path,num)
{
	var roundnum = Math.ceil(Math.random()*(num-1)+1);
	if(roundnum==num)
	{
		var ifnode = document.getElementById(ifrname);
		if( ifnode != null)
		{
   			ifnode.src=adUrl;
   			googleAdStat(path);
   		}
   		else
   		{
   			alert("iframe不存在!");
   		}
   	}
}

/*google广告统计结束*/

/*头部*/
	function changeUrl(info){

		if(info.value == '1'){
			document.getElementById('urlForm').action = "http://news.51hejia.com/articleq.jhtml";
			document.getElementById('q').name = "q";

		}else if(info.value == '2'){
			document.getElementById('urlForm').action = "http://prod.51hejia.com/search!product/tempUrl-1.jhtml";
			document.getElementById('q').name = "q";

		}else if(info.value == '3'){
			document.getElementById('urlForm').action = "http://tuku.51hejia.com/casesq.jhtml";
			document.getElementById('q').name = "q";

		}else if(info.value == '4'){
			document.getElementById('urlForm').action = "http://chat.51hejia.com/commentIndex.jhtml";
			document.getElementById('q').name = "title";

		}else if(info.value == '5'){
			document.getElementById('urlForm').action = "http://yp.51hejia.com/companyqnew.jhtml";
			document.getElementById('q').name = "q";
			//document.getElementById("hotWord").innerHTML = "";
		}

		//alert(urlForm.action);

	}

	function submitForm(){
		if(document.getElementById('q').value.length < 1){
			alert("请输入搜索信息");

		}else{
			document.getElementById('urlForm').submit();
		}
	}

	function submitKeys(urlLink, keys){
		//var info = document.getElementById("_info");

		//if(info.value=='1' || info.value == '2' || info.value=='3'){
		//	urlLink.href=document.getElementById('urlForm').action+"?q="+keys;
		//}else{
		//	urlLink.href=document.getElementById('urlForm').action+"?title="+keys;
		//}

	}



var xmlHttp;
function createXMLHttp(){
    if(window.XMLHttpRequest){
    	xmlHttp = new XMLHttpRequest();        
    }
    else if(window.ActiveXObject){
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
}
function startRequest(doUrl){
    createXMLHttp();
    xmlHttp.onreadystatechange = handleStateChange;
    
    xmlHttp.open("GET", doUrl, true);
    
    xmlHttp.send(null);
    
}

function handleStateChange(){
    if (xmlHttp.readyState == 4 ){
        if (xmlHttp.status == 200 ){
            var strResponse=xmlHttp.responseText;
            if (strResponse!=null && strResponse!='notlogin')
            {
            	document.getElementById("show_login").innerHTML='[<a id="my51" href="http://www.51hejia.com/myHejiaIndex.jhtml" title="我的和家">我的和家</a>] [<a href="http://www.51hejia.com/usersLogin!loginout.jhtml" title="退出">退出</a>]';
            }
         }
    }
}
function doMyAjaxlogin()
{
	
	//var time = Math.random();
	
	//var strPer = 'http://www.51hejia.com/loginForUserName.jhtml?time='+time;
	
	//startRequest(strPer);
}




	function denglula()
	{
		var time = Math.random();
		document.getElementById('dengluiframe').src='http://www.51hejia.com/usersLogin!returnGo.jhtml?time='+time;
	}
	


		
		
	function changecolor(){	
		var strtmpurl=null;
		
		var requesturl = window.location.href;

		if 

(requesturl=='http://shanghai.51hejia.com/'||requesturl=='http://shenzhen.51hejia.com/'||requesturl=='http://beijing.51hejia.com/'||requesturl=='http://guangzhou.51hejia.com/'||requesturl=='http://www.51hejia.com/')
		{
			//strtmpurl = document.getElementById('xinwenzhoukanid');
		}
		if (requesturl=='http://tuku.51hejia.com/')
		{
			strtmpurl = document.getElementById('tukuid');
		}
		if (requesturl.indexOf('http://www.51hejia.com/xinwen/')!=-1)
		{
			strtmpurl = document.getElementById('xinwenzhoukanid');
		}
		if (requesturl=='http://ask.51hejia.com/')
		{
			strtmpurl = document.getElementById('wenbaid');
		}
		if (requesturl.indexOf('/zhuangxiu/')>-1)
		{
			strtmpurl = document.getElementById('zhuangxiuid');
		}
		if (requesturl.indexOf('http://prod.51hejia.com')>-1)
		{
			strtmpurl = document.getElementById('chanpinid');
		}
		if (requesturl.indexOf('/jushang')>-1)
		{
			strtmpurl = document.getElementById('jushangid');
		}
		if (strtmpurl!=null)
		{
			strtmpurl.className='RedNavZhong';
		}
		

		var mouyigeli = null;
		if (requesturl.indexOf('/jiaju/')>-1)
		{
			mouyigeli = document.getElementById('jiajuid');
		}
		if (requesturl.indexOf('/jiancai/')>-1)
		{
			mouyigeli = document.getElementById('jiancaiid');
		}
		if (requesturl.indexOf('/jiadian/')>-1)
		{
			mouyigeli = document.getElementById('jiadianid');
		}
		if (requesturl.indexOf('/zhuangshi/')>-1)
		{
			mouyigeli = document.getElementById('zhuangshiid');
		}
		if (requesturl.indexOf('/chufang/')>-1)
		{
			mouyigeli = document.getElementById('chufangid');
		}
		if (requesturl.indexOf('/weiyu/')>-1)
		{
			mouyigeli = document.getElementById('weiyuid');
		}		
		if (requesturl.indexOf('/youqituliao/')>-1)
		{
			mouyigeli = document.getElementById('tuliaoid');
		}
		if (requesturl.indexOf('/cizhuan/')>-1)
		{
			mouyigeli = document.getElementById('cizhuanid');
		}		
		if (requesturl.indexOf('/kongtiao/')>-1)
		{
			mouyigeli = document.getElementById('kongtiaoid');
		}	
		if (requesturl.indexOf('/chanpin_liebiao.jhtml?tagFId=7921')>-1)
		{
			mouyigeli = document.getElementById('buyiid');
		}		
		if (requesturl.indexOf('/diban/')>-1)
		{
			mouyigeli = document.getElementById('dibanid');
		}		
		if (requesturl.indexOf('/cainuan/')>-1)
		{
			mouyigeli = document.getElementById('cainuanid');
		}		
		if (requesturl.indexOf('/chanpin_liebiao.jhtml?tagFId=12954')>-1)
		{
			mouyigeli = document.getElementById('jiajuid');
		}		
		if (requesturl.indexOf('/chanpin_liebiao.jhtml?tagFId=7919')>-1)
		{
			mouyigeli = document.getElementById('dengjuid');
		}		
		if (requesturl.indexOf('/xiaohuxing/')>-1)
		{
			mouyigeli = document.getElementById('xiaohuxingid');
		}
		if (requesturl.indexOf('/gongyu/')>-1)
		{
			mouyigeli = document.getElementById('gongyuid');
		}
		if (requesturl.indexOf('ershoufang')>-1)
		{
			mouyigeli = document.getElementById('ershoufangid');
		}
		if (requesturl.indexOf('bieshu')>-1)
		{
			mouyigeli = document.getElementById('bieshuid');
		}		
		if (requesturl.indexOf('/zhoukan/')>-1)
		{
			mouyigeli = document.getElementById('zhoukanid');
		}		
		if(requesturl.indexOf('http://shanghai.51hejia.com') != -1)
		{
			mouyigeli = document.getElementById('shanghaiid');
		}
		if(requesturl.indexOf('http://beijing.51hejia.com') != -1)
		{
			mouyigeli = document.getElementById('beijingid');
		}
		if(requesturl.indexOf('http://shenzhen.51hejia.com') != -1)
		{
			mouyigeli = document.getElementById('shenzhenid');
		}
		if(requesturl.indexOf('http://guangzhou.51hejia.com') != -1)
		{
			mouyigeli = document.getElementById('guanghzouid');
		}
						
		if (mouyigeli!=null){
			mouyigeli.className='Red';
		}
	}

/*头部结束*/

/*checklogin*/

/*checklogin结束*/
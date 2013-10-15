/**
 * @author maoqiuyun
 */
function gen_search_url(){
	gen_search_url2();
}
function gen_search_url2(){
	var url = gen_city_domain();
	var city = document.getElementById('cityid').value;
	var district = document.getElementById('districtid').value;
	var style = document.getElementById('styleid').value;
	var model = document.getElementById('modelid').value;
	var price = document.getElementById('priceid').value;
	var order = document.getElementById('orderid').value;
	var keyword = document.getElementById('keywordid2').value;
	var hcase = document.getElementById('hcaseid').value;
	var hcommont = document.getElementById('hcommontid').value
	var url = url + '/zhuangxiugongsi/gsl-'+city+'-'+district+'/'+model+'-'+style+'-'+order+'-'+price+'-'+hcase+'-'+hcommont+'/'
	if(keyword.length>0)
		url = url + '?keyword='+keyword;
	location.href = encodeURI(url);
}

function gen_city_domain(){
	var isProduct = document.getElementById('isProduct').value;
	if (isProduct == 1 || isProduct == '1') {
		var city = document.getElementById('cityid').value;
		if(city == '11910')
			return "http://z.shanghai.51hejia.com";
		else if (city == '12117')
			return "http://z.suzhou.51hejia.com";
		else if (city == '12122')
			return "http://z.nanjing.51hejia.com";
		else if (city == '12301')
			return "http://z.ningbo.51hejia.com";
		else if (city == '12306')
			return "http://z.hangzhou.51hejia.com";
		else if (city == '12118')
			return "http://z.wuxi.51hejia.com";
		else
			return "http://z.51hejia.com";
	}else{
		return '';
	}
}
function changecity(c){
	document.getElementById('cityid').value = c;
	document.getElementById('districtid').value = '0';
	gen_search_url();
}
function changedistrict1(d){
	document.getElementById('districtid').value = d;
}
function changedistrict(d){
            clearRecord('districtid');
	document.getElementById('districtid').value = d;
	gen_search_url();
}
function changeorder(o){
	document.getElementById('orderid').value = o;
	gen_search_url();
}
function changestyle1(s){
	document.getElementById('styleid').value = s;
}
function changestyle(s){
            clearRecord('styleid');
	document.getElementById('styleid').value = s;
	gen_search_url();
}
function changemodel1(m){
	document.getElementById('modelid').value = m;
}
function changemodel(m){
            clearRecord('modelid');
	document.getElementById('modelid').value = m;
	gen_search_url();
}
function changeprice1(p){
	document.getElementById('priceid').value = p;
}
function changeprice(p){
            clearRecord('priceid');
	document.getElementById('priceid').value = p;
	gen_search_url();
}
function changehcase(c){
	if(c)
		document.getElementById('hcaseid').value = '1';
	else
		document.getElementById('hcaseid').value = '0';
	gen_search_url();
}
function changehcommont(c){
	if(c)
		document.getElementById('hcommontid').value = '1';
	else
		document.getElementById('hcommontid').value = '0';
	gen_search_url();
}
      function clearRecord(name)
   {
         	if(name != 'districtid') document.getElementById('districtid').value=0;
	if(name != 'styleid') document.getElementById('styleid').value=0;
	if(name != 'modelid') document.getElementById('modelid').value=0;
	if(name != 'priceid') document.getElementById('priceid').value=0;
	if(name != 'keywordid2') document.getElementById('keywordid2').value="";
   }
//js entityType is not null
function stat2(base,entityId,entityType,entityUrl){
	var token = base+"/go/stat2";
	if(entityUrl != null && entityUrl != ""){
		if(entityUrl.indexOf('.jhtml')>0){
			entityUrl = entityUrl.replace('\.jhtml',"-jhtml");
		}
		if(entityUrl.indexOf('.action')>0){
			entityUrl = entityUrl.replace('\.action',"-action");
		}

		//token +='/entityUrl/'+entityUrl;
	}
	if(entityId != null && entityId != ""){
		if(typeof(entityId)!= 'number'){
			token += '/entityType/'+ entityType + "/entityStr/"+entityId;
		}else{
			token += '/entityType/'+ entityType + "/entityId/"+entityId;
		}
	}
	//document.write(token);
	document.write("<img src="+token+" />");
}

function statProductPhone(base,productId){
	var token = base+"/go/statProductPhone";
	if(productId != null){
		token +="/productId/"+productId;
		document.write("<img src="+token+" />");
	}
}
function statUrl(base){
        //var token = base+"/go/stat2";
        //document.write("<img src="+token+" />");
	stat2(base,"","",document.referrer);
}

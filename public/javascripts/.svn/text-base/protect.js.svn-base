function getSourceContent(id,protectCode) 
{
	var content = document.getElementById(id).innerHTML;
	content = content.replace(new RegExp(protectCode+"和家网-全球中文家居门户"+protectCode,"gm"),"<P><div style='display:none'>和家网-全球中文家居门户</div>");
	content = content.replace(new RegExp(protectCode+"和家网-句号"+protectCode,"gm"),"。<div style='display:none'>和家网-全球中文家居门户</div>");
	content = content.replace(new RegExp(protectCode+"和家网-逗号"+protectCode,"gm"),"，<div style='display:none'>和家网-全球中文家居门户</div>");
	document.getElementById(id).innerHTML = content;
}
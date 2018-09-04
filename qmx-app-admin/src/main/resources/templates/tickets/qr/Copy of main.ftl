<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<style type="text/css"> 
body {text-align: center;}
div {
position: absolute;      /*绝对定位*/   
top: 50%;                  /* 距顶部50%*/   
left: 50%;                  /* 距左边50%*/   
height: 640px;  margin-top: -520px;   /*margin-top为height一半的负值*/   
width: 640px;  margin-left: -320px;    /*margin-left为width一半的负值*/ 
}  
img{
    padding-top:300px;
    padding-bottom:300px;
}
</style>

</head>
<body>
	<#if msg??>
	<h1>${(msg)!}</h1>
	<#else>
	<#list url as dto>
		<img width="640" height="640" src="${dto}" />
		<hr/>
	</#list>
	</#if>
</body>
</html>
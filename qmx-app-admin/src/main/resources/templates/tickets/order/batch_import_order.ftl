[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>批量导订单</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/ajaxupload.js"></script>
<script src="${base}/resources/layer/layer.js"></script>
<script type="text/javascript">
$(function(){
	var token = getCookie("token");
	var $message;
	new AjaxUpload("passengerImportBtn", {
		action : 'batchImportOrder.jhtml?token='+token,
		name : 'file', 
		autoSubmit:true,
		responseType: "json",
		onChange: function(file, ext){
			if (!(ext && /^(xls|xlsx)$/.test(ext))){
				alert("文件格式错误");
				return false;
			}
		},
		onSubmit : function(file, ext) {
			 $message = $.message({
				 type:"warn",
				 content:"正在导入请稍等，导入过程中不要离开当前页面",
				 timeout:-1
			 });
		},
		onComplete : function(file, response) {
			$message.hide();
			if (response.type == "success") {
				var data = response.data;
				alert('导入成功：共导入'+data.length+'条数据，点击确定跳转到订单列表');
				location.href="${base}/admin/order/list";
			} else {
				$.message(response);
			}
		}
	});
})
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			添加订单
	    </div>
	</div>
	<form id="inputForm" action="save.jhtml" method="post">
		<table class="input">
			<tr>
			<th>
				&nbsp;
			</th>
			<td >
				&nbsp;
			</td>
			</tr>
			<tr>
			<th>
				<h2>备注:</h2>
			</th>
				<td >
					<h2 style="color:red;">导入需花费很长时间所以一次导入不要超过200条,导入过程中不要离开当前页面</h2>
				</td>
			</tr>
			<tr>
				<th>
				<h2>从Excel导入订单信息:</h2>
				</th>
				<td>
					<input id="passengerImportBtn" type="button" class="button" value="从Excel导入订单信息"/>
					<a href="${base}/resources/excel/importOrder.xlsx">下载Excel模板</a>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
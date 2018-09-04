<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>产品授权分销商</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/dropdown/dropdown.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/admin/css/ext.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropdown.js"></script>
<script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropqtable.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	$("#productName").dropqtable({
		vinputid: "productId", //值所存放的区域
		dropwidth: "auto", //下拉层的宽度
		selecteditem: { text: "", value: "" }, //默认值
		editable: false,
		tableoptions: {
			autoload: true,
			url: "listProductAuthorizeJson", //查询响应的地址
			qtitletext: "请输入产品名称", //查询框的默认文字  
			textField: 'trueName',
			valueField: 'id',
			colmodel: [
				{ name: "sn", displayname: "产品ID", width: "150px" },
				{ name: "ticketTypeName", displayname: "票型", width: "150px" },
				{ name: "name", displayname: "产品名称", width: "100px" } //表格定义
			],
			onSelect:function(product){
				$("#productId").val(product.id);
				$("#productName").val(product.name);
			}
		}
	});
	
	// 添加分销商
	$("#addDistributorItem").click(function(){
		var browserFrameId = "browserFrame" + (new Date()).valueOf() + Math.floor(Math.random() * 1000000);
		var $browser = $('<div class="xxBrowser" style="height:350px;"><\/div>');
		$browserFrame = $('<iframe id="' + browserFrameId + '" name="' + browserFrameId + '" src="listDistributorForAuthorize" style="width:100%; height:100%;" frameborder="0"><\/iframe>').appendTo($browser);
		var $dialog = $.dialog({
			title: "添加分销商",
			content: $browser,
			width: 570,
			modal: true,
			ok: "确定",
			cancel: "取消",
			onOk: function() {
				var $checkedIds = $(window.frames[browserFrameId].document).find("input[name='ids']:enabled:checked");
				$checkedIds.each(function(){
					var id = $(this).val();
					var tr = $(this).parents("tr:eq(0)");
					if($("tr."+id).size() == 0) {
						addProductItem({id:id,username:tr.find("td:eq(1)").text(),name:tr.find("td:eq(3)").text()});
					}
				});
				return true;
			}
		});
	});
	
	// 删除产品项
	$("#productItemTable a.deleteOrderItem").live("click", function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "确定删除？",
			onOk: function() {
				if($this.attr("data-id")) {
					$.ajax({
						url: "deleteProductDistributor.jhtml",
						type: "POST",
						data: {id: $this.attr("data-id")},
						dataType: "json",
						beforeSend: function(){
						},
						success: function(datas) {
							
						}
					});
				}
				$this.closest("tr").remove();
			}
		});
	});
	
	$.validator.addClassRules({
		distributor: {
			required: true
		},
		productId: {
			required: true,
			integer: true
		}
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			productId: "required",
			distributor: "required"
		},
		messages: {
			sn: {
				pattern: "admin.validate.illegal",
				remote: "admin.validate.exist"
			}
		}
	});
	
});
var productItemIndex = 0;
function addProductItem(data) {
	var repeat = false;
	$("#productItemTable input.productItemId").each(function() {
		var tmp = $(this).val();
		if (tmp == data.id) {
			repeat = true;
			return false;
		}
	});
	if (repeat) {
		return false;
	}
	<@compress single_line = true>
	var $tr = $(
	'<tr class="orderItemTr">
		<td>
			<input type="hidden" name="distributor" class="productItemId" value="' + data.id + '" \/>
		<\/td>
		<td>
			<span title="' + data.username + '">' + data.username + '<\/span>
		<\/td>
		<td>' + data.name + '<\/td>
		<td>
			<a href="javascript:;" class="deleteOrderItem">[删除]<\/a>
		<\/td>
	<\/tr>');
	</@compress>
	$tr.appendTo($("#productItemTable")).find(":text").each(function() {
		var $this = $(this);
		$this.data("value", $this.val());
	});
}

</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			添加产品授权
	    </div>
	</div>
		<form id="inputForm" action="saveDistributionByProduct" method="post">
		<table class="input">
			<tr>
				<th><span class="requiredField">*</span>选择需要授权给分销商的产品：</th>
				<td>
					<input type="hidden" id="productId" name="productId" />
					<input type="text" id="productName" class="text" name="productName" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>已选择要授权的分销商:
				</th>
				<td>
					<input type="button" id="addDistributorItem" class="button" value="选择分销商" />
					<hr />
					<table width="100%" id="productItemTable">
						<tr class="title">
							<td>
							</td>
							<td>
								分销商账号
							</td>
							<td>
								分销商名称
							</td>
							<td>
								操作
							</td>
						</tr>
					</table>
					<div class="blank"></div>
					<span class="tips">说明：</span>
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="下一步" />
					<input type="button" class="button" value="返回" onclick="history.back()" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
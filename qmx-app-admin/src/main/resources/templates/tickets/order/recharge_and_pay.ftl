<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>在线支付</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<style type="text/css">
.roles label {
	width: 150px;
	display: block;
	float: left;
	padding-right: 5px;
}
</style>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	
	[@flash_message /]
	
	// 表单验证
	$inputForm.validate({
		rules: {
			amount: {
				required: true,
				positive: true,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			}
		},
		messages: {
			password: {
			}
		}
	});
	
	$inputForm.submit(function(){
		if($(this).valid()) {
			$.dialog({
				title: "请在新打开的页面中完成付款",
				content: '<div class="dialogwarnIcon">请在新打开的页面中完成付款<br/>付款完成前请不要关闭此窗口<br/>完成付款后请点击下面按钮</div>',
				width: 400,
				modal: true,
				ok: "完成付款",
				cancel: "遇到问题",
				onShow: function() {
					$("#other").click(function(){
						
					});
				},
				onOk: function(){
					location.reload(true);
					return false;
				},
				onClose: function(){
					location.reload(true);
					return false;
				}
			});
		}
	});

});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			在线支付
	    </div>
	</div>
	<form id="inputForm" action="../payment/submit.jhtml" method="post" target="_blank">
		<input type="hidden" name="type" value="rechargeAndPay" />
		<input type="hidden" name="sn" value="${order.sn}" />
		<table class="input">
			<tr>
				<th>
					订单编号:
				</th>
				<td>
					${order.sn}
				</td>
			</tr>
			<tr>
				<th>
					钱包金额:
				</th>
				<td>
					${currency(wallet, true, true)}
				</td>
			</tr>
			<tr>
				<th>
					应付金额:
				</th>
				<td>
					${currency(order.amount-wallet, true, true)}
				</td>
			</tr>
			<tr>
				<th>
					支付方式:
				</th>
				<td>
					<div id="paymentPlugin" class="paymentPlugin clearfix">
						[#if order.supplier.aliEnable]
								<label for="alipayDirectPlugin">
								<div style="margin: 4px; float: left; border: solid 1px #dddddd; width: 153px; height: 36px;">
										<input type="radio" id="alipayDirectPlugin" name="paymentPluginId" value="alipayDirectPlugin" checked="checked" />
										<img title="支付宝支付" alt="支付宝支付" src="${base}/resources/payment_plugin/alipay.gif" width="116" height="34" />
								</div>
								</label>
						[/#if]
						[#if order.supplier.wxEnable]
								<label for="wxpayPlugin">
								<div style="margin: 4px; float: left; border: solid 1px #dddddd; width: 153px; height: 36px;">
										<input type="radio" id="wxpayPlugin" name="paymentPluginId" value="wxpayPlugin" />
										<img title="微信支付" alt="微信支付" src="${base}/resources/payment_plugin/wxpay.gif" width="116" height="34" />
								</div>
								</label>
						[/#if]
					</div>
				</td>
			</tr>
		</table>
		<table class="input">
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="${message("admin.common.submit")}" />
					<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back()" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
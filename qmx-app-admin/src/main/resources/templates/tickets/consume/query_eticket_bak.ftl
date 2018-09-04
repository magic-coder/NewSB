<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>电子票列表</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript">
$().ready(function() {
	
});
</script>
</head>
<body>
	<form action="consumeByIds" method="post">
		<input type="hidden" name="sn" value="${sn}" />
		<input type="hidden" name="token" value="${token}" />
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th><span>#</span></th>
				<th><span>联系人</span></th>
				<th><span>客人信息</span></th>
				<th>
					<span>购买产品</span>
				</th>
				<th>
					<span>支付方式</span>
				</th>
				<th>
					<span>游玩日期</span>
				</th>
				<th>
					<span>下单日期</span>
				</th>
				<th>
					<span>是否有效</span>
				</th>
			</tr>
			<#list list as ad>
				<tr>
					<td>
						<#if ad.state == 'NORMAL' && !ad.useState>
						<input type="checkbox" name="ids" value="${ad.id}" />
						</#if>
					</td>
					<td>${ad_index+1}</td>
					<td>
						${ad.customerName}
					</td>
					<td>
						${ad.name!}/${ad.credentialsNo!}
					</td>
					<td>
						<span title="${ad.productName}">
							${ad.productName}
						</span>
					</td>
					<td>
						ad.order.paymentMethod.name
					</td>
					<td>
						<#if ad.vsdate?string('yyyy-MM-dd') == ad.vedate?string('yyyy-MM-dd')>
							${ad.vsdate?string('yyyy-MM-dd')}当天
						<#else>
							${ad.vsdate?string('yyyy-MM-dd')}<br/>${ad.vedate?string('yyyy-MM-dd')}
						</#if>

					</td>
					<td>
						<span title="${ad.createTime?datetime}">${ad.createTime?datetime}</span>
					</td>
					<td>
						<#if ad.state != 'NORMAL'>
						<font color="red">${ad.state.getName()}</font>
						<#else>
						${ad.state.getName()}
						</#if>
					</td>
				</tr>
			</#list>
		</table>
	</form>
</body>
</html>
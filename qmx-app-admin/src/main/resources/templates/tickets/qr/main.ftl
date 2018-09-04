<!DOCTYPE html>
<html lang="zh_cn">
<head>
<title>扫码二维码</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0"/>
<style type="text/css">
table {
	width: 100%;
	border-collapse: collapse;
	position: relative;
	margin-top:60%;
	margin-right:20%;
}

th,td {
	border: thin solid rgb(193, 210, 227);
	padding: 5px;
}

th {
	background-color: rgb(218, 234, 251);
}
</style>
</head>
<body style="margin:15px;">
<center>
<#if msg??>
	<h1>${(msg)!}</h1>
        <#else>
        <#list url as dto>
		<img src="${dto}" width="40%" style="position:absolute; top: 10%;left:50%;margin-left:-20%;"/>
		<table>
			<tbody>
				<tr>
					<td colspan="2">门票名称：${ticketName}</td>
				</tr>
				<#--<tr>
					<td colspan="2">使用时间：
					[#if limitUseTimeRange?? && limitUseTimeRange]
					${useTimeRangeStart}~${useTimeRangeEnd}
					[#else]
					不限
					[/#if]
					</td>
				</tr>-->
				<tr>
					<td colspan="2">有效日期：${date} 至 ${edate}</td>
				</tr>
				<tr>
					<td colspan="2">下单时间：${createDate?datetime}</td>
				</tr>
				<tr>
					<td colspan="2">
					<span style="color:red;">
        <#if status = 'NORMAL'>
					当前时间可用
        <#elseif status='NOTVALID'>
					使用时间未到
        <#elseif status='EXPIRYDATE'>
					可使用时间已过
        </#if></span>
					</td>
				</tr>
				<tr>
					<td colspan="2">联系人(手机):${contactName}（${contactMobile}）</td>
				</tr>
				<tr>
					<td colspan="2">订单来源:${orderSource}</td>
				</tr>
				<tr>
					<td colspan="2">订单数量：${quantity}</td>
				</tr>
				<tr>
					<td colspan="2">消费数量：${consumeQuantity}</td>
				</tr>
				<tr>
					<td colspan="2">退款数量：${refundQuantity}</td>
				</tr>
				<#--
				<tr>
					<td colspan="2">可使用日期：${canUseDate?string("yyyy-MM-dd HH:mm:ss")}</td>
				</tr>
				-->
</tbody>
</table>
</#list>
</#if>
</center>
</body>
</html>
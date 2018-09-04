<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.refunds.view")}</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {
	
	[@flash_message /]
	
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			${message("admin.refunds.view")}
	    </div>
	</div>
	<table class="input">
		<tr>
			<th>
				${message("Refunds.sn")}:
			</th>
			<td>
				${refunds.sn}
				[#if refunds.outSn??]
				[外平台号码:${refunds.outSn}]
				[/#if]
			</td>
			<th>
				${message("admin.common.createDate")}:
			</th>
			<td>
				${refunds.createDate?string("yyyy-MM-dd HH:mm:ss")}
			</td>
		</tr>
		<tr>
			<th>
				${message("Refunds.method")}:
			</th>
			<td>
				${message("Refunds.Method." + refunds.method)}
			</td>
			<th>
				${message("Refunds.paymentMethod")}:
			</th>
			<td>
				${(refunds.paymentMethod)!"-"}
			</td>
		</tr>
		<tr>
			<th>
				${message("Refunds.bank")}:
			</th>
			<td>
				${(refunds.bank)!"-"}
			</td>
			<th>
				${message("Refunds.account")}:
			</th>
			<td>
				${(refunds.account)!"-"}
			</td>
		</tr>
		<tr>
			<th>
				${message("Refunds.payee")}:
			</th>
			<td>
				${(refunds.payee)!"-"}
			</td>
			<th>
				${message("Refunds.amount")}:
			</th>
			<td>
				[#assign amount = refunds.amount/]
				[#list refunds.order.orderPrices as price]
				[#if price.member == member]
				[#assign amount = price.price*refunds.quantity/]
				[#break/]
				[/#if]
				[/#list]
				${currency(amount, true)}
			</td>
		</tr>
		<tr>
			<th>
				${message("Refunds.order")}:
			</th>
			<td>
				${refunds.order.sn}
			</td>
			<th>
				${message("Refunds.operator")}:
			</th>
			<td>
				${refunds.operator}
			</td>
		</tr>
		<tr>
			<th>
				退款数量:
			</th>
			<td>
				${refunds.quantity}
				[${message("Refunds.State." + refunds.state)}]
			</td>
			<th>
				${message("Refunds.memo")}:
			</th>
			<td>
				${refunds.memo}
			</td>
		</tr>
		<tr>
			<th>
				&nbsp;
			</th>
			<td colspan="3">
				<input type="button" class="button" value="${message("admin.common.back")}" onclick="history.back();" />
			</td>
		</tr>
	</table>
</body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>订单查看</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			查看
	    </div>
	</div>
	<ul id="tab" class="tab">
		<li>
			<input type="button" value="订单信息" />
		</li>
		<li>
			<input type="button" value="退款信息" />
		</li>
		<li>
			<input type="button" value="订单日志" />
		</li>
		<@shiro.hasPermission name="admin:viewTicket">
		<li>
			<input type="button" value="电子票" />
		</li>
		</@shiro.hasPermission>
	</ul>
	<table class="input tabContent">
		<tr>
			<th>
				订单号:
			</th>
			<td width="360">
				${order.id}
				<#if order.outSn??>[OTA订单号：${order.outSn}]</#if>
				<#if order.outSn1??>[第三方订单号：${order.outSn1}]</#if>
			</td>
			<th>
				添加时间:
			</th>
			<td>
				${order.createTime?datetime}
			</td>
		</tr>
		<tr>
			<th>
				产品名称（ID）:
			</th>
			<td width="360">
				${order.productName!}（${order.priceSn!}）
			</td>
			<th>
				供应商:
			</th>
			<td>
				${order.supplierAccount!}
			</td>
		</tr>
		<tr>
			<th>
				单价:
			</th>
			<td width="360">
				${order.salePrice?string("0.00")}
			</td>
			<th>
				退款数量:
			</th>
			<td>
				${order.returnQuantity!}
			</td>
		</tr>
        <tr>
            <th>
                支付金额:
            </th>
            <td width="360">
			${order.amountPaid?string("0.00")}
                （优惠金额:${order.totalDiscount?string("0.00")}）
            </td>
            <th>
                总价:
            </th>
            <td width="360">
			${order.totalAmount?string("0.00")}
            </td>
        </tr>
		<tr>
			<th>
				订单状态:
			</th>
			<td>
				${order.orderStatus!}
			</td>
			<th>
				支付状态:
			</th>
			<td>
				${order.payStatus.getName()}
				<#if order.payTime??>
				${order.payTime?datetime}
				</#if>
			</td>
		</tr>
		<tr>
			<th>
				发货状态:
			</th>
			<td>
				<#if order.shippingStatus??>
					${order.shippingStatus.getName()}
				<#else>
					-
				</#if>
			</td>
			<th>
				退款状态:
			</th>
			<td>
				${order.refundStatus.getName()}
			</td>
		</tr>
		<tr>
			<th>
				订单来源:
			</th>
			<td>
				${order.orderSourceName!}
			</td>
			<th>
				数量:
			</th>
			<td>
				${order.quantity}
			</td>
		</tr>
		<tr>
			<th>
				支付方式:
			</th>
			<td>
				<#if order.paymentMethod??>
				    ${order.paymentMethod.getName()!}
				</#if>
			</td>
			<th>
				短信模版:
			</th>
			<td>
				${order.smsTemplate.name}
			</td>
		</tr>
		<tr>
			<th>
				下单人:
			</th>
			<td>
				${order.createUserAccount!}
			</td>
			<th>
				所属人:
			</th>
			<td>
				${order.memberAccount!}
			</td>
		</tr>
		<tr>
			<th>
				联系人:
			</th>
			<td>
				${order.contactMobile} ${order.contactName}
			</td>
			<th>
				使用有效期:
			</th>
			<td>
				<#if order.vsdate?? && order.vedate?? && order.vsdate == order.vedate>
				${order.vsdate}当天有效
				<#else>
				${order.vsdate!}-${order.vedate!}
				</#if>
			</td>
		</tr>
		<tr>
			<th>
				线下同步状态:
			</th>
			<td>
				没有同步数据
			</td>
			<th>
				&nbsp;
			</th>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<th>
				客人信息:
			</th>
			<td colspan="3">
				<table width="100%">
				<tr class="title">
					<th>姓名</th>
					<th>拼音</th>
					<th>手机</th>
					<th>证件</th>
					<th>证件号</th>
					<th>自定义1</th>
					<th>自定义2</th>
				</tr>
					<#if order.passengerInfos??>
						<#list order.passengerInfos as passenger>
                            <tr>
                                <td>${passenger.name}</td>
                                <td>${passenger.pinyin}</td>
                                <td>${passenger.mobile}</td>
                                <td<#if passenger.credentialsType??>${message("PassengerInfo.CredentialsType."+passenger.credentialsType)}</#if></td>
                                <td>${passenger.credentials}</td>
                                <td>${passenger.defined1}</td>
                                <td>${passenger.defined2}</td>
                            </tr>
						</#list>
					</#if>
				</table>
			</td>
		</tr>
		<tr>
			<th>备注:</th>
			<td colspan="3">${order.remark!}</td>
		</tr>
	</table>
	<table class="input tabContent">
		<tr class="title">
			<th>
				退款流水号
			</th>
			<th>
				退款方式
			</th>
			<th>
				支付方式
			</th>
			<th>
				退订数量
			</th>
			<th>
				添加时间
			</th>
		</tr>
		<#if order.refunds??>
			<#list order.refunds as refunds>
                <tr>
                    <td>
					${refunds.sn}
                    </td>
                    <td>
					${message("Refunds.Method." + refunds.method)}
                    </td>
                    <td>
					${refunds.paymentMethod!"-"}
                    </td>
                    <td>
					${refunds.quantity}
                    </td>
                    <td>
					${refunds.createDate?string("yyyy-MM-dd HH:mm:ss")}
                    </td>
                </tr>
			</#list>
		</#if>
	</table>
	<table class="input tabContent">
		<tr class="title">
			<th>
				日志类型
			</th>
			<th>
				操作员
			</th>
			<th>
				时间
			</th>
            <th>
                备注
            </th>
		</tr>
		<#if order.orderLogs??>
			<#list order.orderLogs as orderLog>
                <tr>
                    <td>
					${orderLog.operation!}
                    </td>
                    <td>
					${orderLog.operator}
                    </td>
                    <td>
					${orderLog.createTime?datetime}
                    </td>
                    <td>
						${orderLog.remark!}
                    </td>
                </tr>
			</#list>
		</#if>
	</table>
	<@shiro.hasPermission name="admin:viewTicket">
	<table class="input tabContent">
		<tr class="title">
			<th>
				电子票
			</th>
			<th>
				是否使用
			</th>
			<th>
				外部票号
			</th>
		</tr>
        <#list order.etickets as eticket>
			<tr>
				<td>
					${eticket.sn}
				</td>
				<td>
					${eticket.useState?string('<font color="red">已使用</font>','未使用')}
				</td>
				<td>
					${eticket.outsn}
				</td>
			</tr>
        </#list>
	</table>
	</@shiro.hasPermission>
</body>
</html>
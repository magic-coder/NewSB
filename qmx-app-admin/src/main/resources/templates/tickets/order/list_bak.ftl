<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>订单列表</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<style>
.synchro_prompt{
		color:#81d8fc;
		border:solid 1px #81d8fc;
		display: inline-block;
	}
</style>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap-paginator.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $listForm = $("#listForm");
	var $filterSelect = $("#filterSelect");
	var $filterOption = $("#filterOption a");
	var $print = $("select.print");
	var $paymentButton = $(".paymentButton");
	var $shippingButton = $(".shippingButton");
	var $refundsButton = $(".refundsButton");
	var $cancelButton = $(".cancelButton");
	
	// 退款
	$refundsButton.click(function() {
		var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
		
		if($checkedIds.length == 1){
			if(!$(".selected > td >a").hasClass("shippingTrue")){
				alert("此记录已退款");
				return false;
			}
		} else {
			alert("你还未选中记录或选择了多条记录");
			return false;
		}
		
		$.ajax({
			url: "preRefunds.jhtml?orderId="+$checkedIds.val(),
			type: "GET",
			cache: false,
			success: function(message) {
				$.dialog({
					title: "退款",
					content: message,
					width: 900,
					modal: true,
					ok: "ok",
					cancel: "cancel",
					onShow: function() {
						$("#refundsForm").validate({
							rules: {
								quantity: {
									required: true,
									integer: true,
									min: 1
								}
							}
						});
					},
					onClose: function() {
						$("#refundsForm").remove();
					},
					onOk: function(){
						$("#refundsForm").submit();
						//return false;
					}
				});
			}
		});
	});
	
	// 发货
	$shippingButton.click(function() {
		var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
		
		if($checkedIds.length == 1){
			//if(!$(".selected > td >a").hasClass("shippingTrue")){
			//	alert("此记录不能发货");
			//	return false;
			//}
		} else {
			alert("你还未选中记录或选择了多条记录");
			return false;
		}
		
		$.ajax({
			url: "orderShipping?orderId="+$checkedIds.val(),
			type: "GET",
			cache: false,
			success: function(message) {
				alert(message);
			}
		});
	});
	
	$paymentButton.click(function() {
		var $this = $(this);
		$.ajax({
			url: "prePayment.jhtml?orderId="+$(this).attr("data-id"),
			type: "GET",
			cache: false,
			success: function(message) {
				$.dialog({
					title: "支付",
					content: message,
					width: 900,
					modal: true,
					ok: "ok",
					cancel: "cancel",
					onShow: function() {
						var $method = $("#method");
						$.validator.addMethod("balance", 
							function(value, element, param) {
								return this.optional(element) || $method.val() != "deposit" || parseFloat(value) <= parseFloat(param);
							},
							"admin.order.insufficientBalance"
						);
						$("#paymentForm").validate({
							rules: {
								amount: {
									required: true,
									positive: true,
									balance: $this.attr("balance"),
									max: $this.attr("amountPayable"),
									decimal: {
										integer: 12,
										fraction: 2
									}
								}
							}
						});
					},
					onOk: function() {
						$("#paymentForm").submit();
						//return false;
					}
				});
			}
		});
	});
	
	$cancelButton.click(function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "确定取消？",
			onOk: function() {
				$("#cancelForm input[name=id]").val($this.attr("data-id"));
				$("#cancelForm").submit();
			}
		});
	});
	
	//编辑
	$(".but").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length == 1){
			var val = $(".selected > td > input").val();
			location.href="edit.jhtml?id="+val;
		}else{
			alert("你还未选中记录或选择了多条记录");
			return false;
		}
	});
	<@shiro.hasPermission name = "admin:noticeOrderConsume">
	$("a[name='noticeOrderConsume']").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定该订单已消费？",
				onOk: function() {
					$.ajax({
						url: "../../open/noticeOrderStatus/noticeConsumed.do?appkey=${member.appkey}",
						type: "POST",
						data: $checkedIds.serialize()+"&uid=${principal.id}",
						dataType: "json",
						cache: false,
						success: function(message) {
							alert(message.msg);
							if (message.success == true) {
								location.reload(true);
							}
						}
					});
				}
			});
			return false;
		}else{
			alert("您未选中记录!");
		}
	});
	</@shiro.hasPermission>
});

var flag = 0
function syncOrder(orderid){
	if(flag == 0){
		flag = 1;
		var map = {};
		map.id = orderid;
		$.ajax({
     			type:"post",
				url:"syncOrder.do",
				data: map,
				dataType:'json',
				success: function(data){
					if(data.code == 1){
						alert(data.msg);
						window.location.reload();
					}else{
						alert(data.msg);
					}
					
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
   					showDialog("info",errorThrown,"错误",320);
   				}
     	});
		flag = 0;
	}
}
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			订单列表
	    </div>
	</div>
	<form id="listForm" action="orderList" method="get">
		<div class="bar">
			<input type="text" name="name" value="${queryDto.name!}" placeholder="客户姓名" />
			<input type="text" name="mobile" value="${queryDto.mobile!}" placeholder="手机号码/电子票号" />
			<input type="text" name="sn" value="${queryDto.sn!}" placeholder="订单编号" />
			<input type="text" name="outsn" value="${queryDto.outsn!}" placeholder="外平台订单编号" />
			<input type="text" name="productSn" value="${queryDto.productSn!}" placeholder="产品ID" />
			<input type="text" name="seller" value="${queryDto.seller!}" placeholder="销售人员" />
			<input type="text" name="memo" value="${queryDto.remark!}" placeholder="备注" />
			<input id="startDate" type="text" class="text Wdate" name="startDate" onclick="WdatePicker()" placeholder="购买时间起" value="${queryDto.startDate!}"/>
			<input id="endDate" type="text" class="text Wdate" name="endDate" onclick="WdatePicker({minDate: '#F{$dp.$D(\'startDate\')}'})" placeholder="购买时间止" value="${queryDto.endDate!}"/>
			<input id="startDate1" type="text" class="text Wdate" name="consumeStartDate" onclick="WdatePicker()" placeholder="消费时间起" value="${queryDto.consumeStartDate!}"/>
			<input id="endDate1" type="text" class="text Wdate" name="consumeEndDate" onclick="WdatePicker({minDate: '#F{$dp.$D(\'startDate1\')}'})" placeholder="消费时间止" value="${queryDto.consumeEndDate!}"/>
			<select name="paymentStatus">
				<option value="">--支付状态--</option>
				<option value="unpaid"<#if queryDto.payStatus?? && queryDto.payStatus == "unpaid"> selected</#if>>未支付</option>
				<option value="paid"<#if queryDto.payStatus?? && queryDto.payStatus == "paid"> selected</#if>>已支付</option>
			</select>
			<select name="refundStatus">
				<option value="">--退款状态--</option>
				<option value="noRefund"<#if queryDto.refundStatus?? && queryDto.refundStatus == "noRefund"> selected</#if>>未退款</option>
				<option value="applied"<#if queryDto.refundStatus?? && queryDto.refundStatus == "applied"> selected</#if>>退款中</option>
				<option value="partialRefunds"<#if queryDto.refundStatus?? && queryDto.refundStatus == "partialRefunds"> selected</#if>>部分退款</option>
				<option value="refunded"<#if queryDto.refundStatus?? && queryDto.refundStatus == "refunded"> selected</#if>>已退款</option>
			</select>
			<select name="shippingStatus">
				<option value="">--发货状态--</option>
				<option value="unshipped"<#if queryDto.shippingStatus?? && queryDto.shippingStatus == "unshipped"> selected</#if>>未发货</option>
				<option value="shipped"<#if queryDto.shippingStatus?? && queryDto.shippingStatus == "shipped"> selected</#if>>已发货</option>
			</select>
            <select name="queryType">
                <option value="">--订单类型--</option>
				<#list queryTypes as qt>
                    <option value="${qt}"<#if queryDto.queryType?? && queryDto.queryType == qt> selected</#if>>${qt.getName()}</option>
				</#list>
            </select>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='orderList';">重置</button>
		</div>
		<div class="bar">
			<@shiro.hasPermission name = "admin:addTicketsOrder">
				<a href="/tickets/order/ticketsList" class="button">添加订单</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:editTicketsOrder">
			<a href="javascript:;" class="but button">修改订单</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:shippingTicketsOrder">
			<a href="javascript:;" class="shippingButton button">订单发码</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:refundTicketsOrder">
			<a href="javascript:;" class="refundsButton button">申请退款</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:exportTicketsOrder">
			<a href="list.jhtml?${queryString!}&op=export" class="button">导出</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:resendOrderConsumeNotify">
			<a href="javascript:;" name="noticeOrderConsume" class="button">通知订单消费</a>
			</@shiro.hasPermission>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="contactName">客户信息</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="fullName">产品名称(ID)</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="orderSource">订单来源</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="quantity">数量</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="totalAmount">总金额</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="paymentStatus">支付状态</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="orderStatus">订单状态</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="refundStatus">退款状态</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="shippingStatus">发货状态</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="operator">销售人员</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createDate">购买日期</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="date">使用日期</a>
				</th>
				<th width="110">
					消费时间
				</th>
				<th width="100">
					同步状态
				</th>
				<th>
					<span>操作</span>
				</th>
			</tr>
			<#assign totalQuantity = 0>
			<#assign totalAmount = 0>
			<#assign totalConsume = 0>
			<#list page.records as order>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${order.id}" />
					</td>
					<td>
						<span title="${order.contactName!}">${order.contactName!}
						<br/>${order.contactMobile}</span>
					</td>
					<td>
						<span title="${order.productName}">
							${order.productName!}
							(${(order.priceSn)})
						</span>
						<#if order.productSource != 'local' && order.paymentStatus='paid'>
							<#if order.needSyn && order.synSuccess>
							<span class="synchro_prompt">已同步</span>
							<#elseif order.needSyn && order.orderStatus !='cancelled' && order.refundStatus = 'noRefund'>
							<span class="synchro_prompt">
								<a href="javascript:;" onclick="syncOrder(${order.id!});">同步</a>
							</span>
							</#if>
						</#if>
					</td>
					<td>
						<#if order.orderSource??>
							<#assign orderSource = order.orderSource.name/>
						</#if>
						<@shiro.hasRole name="supplier">
							<#if order.supplier2?? && order.supplier2 == member>
								<#assign orderSource = order.supplier.name +"("+ order.supplier.username+")"/>
							</#if>
						</@shiro.hasRole>
						${orderSource!}
						<#if order.productQrcode??>
						<br/>【${order.productQrcode.title}】
						</#if>
					</td>
					<td>
						${order.quantity}
					</td>
					<td>
						<@shiro.hasRole name="supplier">
							<#assign amount = order.settlePrice />
						</@shiro.hasRole>
						<@shiro.lacksRole name="supplier">
							<#assign amount = order.totalAmount />
						</@shiro.lacksRole>
						${amount?string("0.##")}
					</td>

					<#assign totalQuantity = totalQuantity+order.quantity>
					<#assign totalAmount = totalAmount+amount>
					<td>
						${order.payStatus.getName()}
					</td>
					<td>
					<#if order.consumeQuantity gt 0>
						<font color="green">已消费 [${order.consumeQuantity}]</font>
					<#else>
					${order.orderStatus!}
					</#if>
					</td>
				<#assign totalConsume = totalConsume+order.consumeQuantity>
					<td>
						<#if order.refundStatus == 'applied' || order.refundStatus == 'refunded'>
						<font color="red">退款中</font>
						<#else>
						<font color="green">未退款</font>
					</#if>
						<#if order.refundStatus == 'refunded' || order.refundStatus == 'partialRefunds'>
						[<font color="red">${order.returnQuantity}</font>]
					</#if>
					</td>
					<td>
						<#if order.shippingStatus??>
							${order.shippingStatus.getName()}
						<#else>
							-
						</#if>

					</td>
					<td>
					<#if order.supplier2?? && order.supplier2 == member>
							${order.createUser.username}
					<#else>
							${order.createUser.username}
							(${order.createUser.account})
					</#if>
					</td>
					<td>
						<span title="${order.createTime?datetime}">${order.createTime?datetime}</span>
					</td>
					<td>
						<#if order.beginDate?? && order.endDate?? && order.beginDate == order.endDate>
						${(order.beginDate)!}当天
						<#else >
						${(order.beginDate)!}<br/>${order.endDate!}
						</#if>
					</td>
					<td>
					<#if order.consumeDate??>
						${order.consumeDate?datetime}
					</#if>
					</td>
					<td>
					<#if order.offLineStatus =='NotSynchronized'>
						线下【未同步】
					<#elseif order.offLineStatus =='Synchronized'>
						线下【已同步】
					<#elseif order.offLineStatus =='No'>
						无需同步
					</#if>
					</td>
					<td>
						<#if order.payStatus =='UNPAID'>
                            <a href="payOrderPage?orderId=${order.id}">[支付]</a>
						</#if>
						<a href="view?id=${order.id}">[详情]</a>
						<@shiro.hasPermission name = "admin:shippingOrder">
					<#if (!order.expired && order.paymentStatus == "paid" && order.orderStatus == "inited" && order.refundStatus != "refunded" && order.refundStatus != "applied")>
							<a class="shippingTrue"></a>
					<#--<a href="javascript:;" class="shippingButton" data-id="${order.id}">[发货]</a>-->
					<#else>
							<a class="shippingFalse"></a>
					<#--发货-->
					</#if>
						</@shiro.hasPermission>
						
						<@shiro.hasPermission name = "admin:refundsOrder">
					<#if (!order.expired && order.orderStatus == "inited" && order.paymentStatus == "paid" && (order.refundStatus == "noRefund" || order.refundStatus == "partialRefunds"))>
							<a class="refundsTrue"></a>
					<#--<a href="javascript:;" class="refundsButton" data-id="${order.id}">[退款]</a>-->
                <#else>
                        <a class="refundsFalse"></a>
                <#--退款-->
					</#if>
						</@shiro.hasPermission>
					</td>
				</tr>
		</#list>
			<tr>
					<td>
					</td>
					<td>
						本页合计
					</td>
					<td>
					</td>
					<td>
					</td>
					<td>
						${totalQuantity!}
					</td>
					<td>
						${totalAmount!}
					</td>
					<td>
					</td>
					<td>
						${totalConsume!}
					</td>
					<td>
					</td>
					<td>
					</td>
					<td>
					</td>
					<td>
					</td>
					<td>
					</td>
					<td>
					</td>
				</tr>
		</table>
			<#include "/include/pagination.ftl">
	</form>
</body>
</html>
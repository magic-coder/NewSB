[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.order.list")}</title>
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

	[@flash_message /]
	
	$(".agreeBtn").click(function(){
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "同意审核？",
			ok: message("admin.dialog.ok"),
			cancel: message("admin.dialog.cancel"),
			onOk: function() {
				$.ajax({
					url: "agree.jhtml",
					type: "POST",
					data: {id: $this.attr("data-id")},
					dataType: "json",
					beforeSend: function(){
					},
					success: function(message) {
						$.message(message);
						setTimeout(function() {
							location.reload(true);
						}, 2000);
					}
				});
			}
		});
	});
	
	$(".disagreeBtn").click(function(){
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "不同意审核？",
			ok: message("admin.dialog.ok"),
			cancel: message("admin.dialog.cancel"),
			onOk: function() {
				$.ajax({
					url: "disagree.jhtml",
					type: "POST",
					data: {id: $this.attr("data-id")},
					dataType: "json",
					beforeSend: function(){
					},
					success: function(message) {
						$.message(message);
						setTimeout(function() {
							location.reload(true);
						}, 2000);
					}
				});
			}
		});
	});
	
	// 退款
	$refundsButton.click(function() {
		var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
		
		if($checkedIds.length == 1){
			if(!$(".selected > td >a").hasClass("refundsTrue")){
				alert("此记录已退款");
				return false;
			}
		} else {
			alert("你还未选中记录或选择了多条记录");
			return false;
		}
		
		location.href= "preRefunds.jhtml?orderId="+$checkedIds.val();
	});
	
	// 发货
	$shippingButton.click(function() {
		var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
		
		if($checkedIds.length == 1){
			if(!$(".selected > td >a").hasClass("shippingTrue")){
				alert("此记录不能发货");
				return false;
			}
		} else {
			alert("你还未选中记录或选择了多条记录");
			return false;
		}
		
		$.ajax({
			url: "preShipping.jhtml?orderId="+$checkedIds.val(),
			type: "GET",
			cache: false,
			success: function(message) {
				$.dialog({
					title: "${message("admin.order.shipping")}",
					content: message,
					width: 900,
					modal: true,
					ok: "${message("admin.dialog.ok")}",
					cancel: "${message("admin.dialog.cancel")}",
					onShow: function() {
						$("#shippingForm").validate({
							rules: {
								contactMobile: "required",
							}
						});
					},
					onClose: function() {
						$("#shippingForm").remove();
					},
					onOk: function(){
						$("#shippingForm").submit();
						//return false;
					}
				});
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
					title: "${message("admin.order.payment")}",
					content: message,
					width: 900,
					modal: true,
					ok: "${message("admin.dialog.ok")}",
					cancel: "${message("admin.dialog.cancel")}",
					onShow: function() {
						var $method = $("#method");
						$.validator.addMethod("balance", 
							function(value, element, param) {
								return this.optional(element) || $method.val() != "deposit" || parseFloat(value) <= parseFloat(param);
							},
							"${message("admin.order.insufficientBalance")}"
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
										fraction: ${setting.priceScale}
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
			content: "${message("admin.order.cancelDialog")}",
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
	
	[@shiro.hasPermission name = "admin:noticeTuniuOrderConsumed"]
	$("a[name='noticeTuniuOrderConsumed']").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定途牛该订单已消费？",
				onOk: function() {
					$.ajax({
						url: "../../open/tuniu/noticeOrderConsume.do",
						type: "POST",
						data: $checkedIds.serialize()+"&uid=${principal.id}",
						dataType: "json",
						cache: false,
						success: function(message) {
							alert(message);
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
	[/@shiro.hasPermission]
	[@shiro.hasPermission name = "admin:noticeOrderConsume"]
	$("a[name='noticeOrderConsume']").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定该订单已消费？",
				onOk: function() {
					$.ajax({
						url: "../../open/noticeOrderStatus/noticeConsumed.do",
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
	[/@shiro.hasPermission]
	
	$("#cancelledButton").click(function() {
		if($("tr").hasClass("selected") && $(".selected").length != 0){
			var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
			$.dialog({
				type: "warn",
				content: "确定要取消订单？",
				onOk: function() {
					$.ajax({
						url: "cancelled.jhtml",
						type: "POST",
						data: $checkedIds.serialize(),
						dataType: "json",
						cache: false,
						success: function(message) {
							$.message(message);
							if (message.type == "success") {
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
			${message("admin.order.list")} 
	    </div>
	</div>
	<form id="listForm" action="taBigCustomerList.jhtml" method="get">
		<div class="bar">
			<input type="text" name="name" value="${name}" placeholder="客户姓名" />
			<input type="text" name="mobile" value="${mobile}" placeholder="手机号码" />
			<input type="text" name="sn" value="${sn}" placeholder="订单编号" />
			[#--<input type="text" name="outsn" value="${outsn}" placeholder="外平台订单编号" />--]
			<input type="text" name="productSn" value="${productSn}" placeholder="产品ID" />
			[#--<input type="text" name="seller" value="${seller}" placeholder="销售人员" />--]
			<input type="text" name="memo" value="${memo}" placeholder="备注" />
			<input id="startDate" type="text" class="text Wdate" name="startDate" onclick="WdatePicker()" placeholder="购买时间起" value="${startDate}"/>
			<input id="endDate" type="text" class="text Wdate" name="endDate" onclick="WdatePicker({minDate: '#F{$dp.$D(\'startDate\')}'})" placeholder="购买时间止" value="${endDate}"/>
			[#--<input id="startDate1" type="text" class="text Wdate" name="consumeStartDate" onclick="WdatePicker()" placeholder="消费时间起" value="${consumeStartDate}"/>
			<input id="endDate1" type="text" class="text Wdate" name="consumeEndDate" onclick="WdatePicker({minDate: '#F{$dp.$D(\'startDate1\')}'})" placeholder="消费时间止" value="${consumeEndDate}"/>--]
			[#--<select name="productCategoryId">
				<option value="">--${message("Product.productCategory")}--</option>
				[#list productCategoryTree as productCategory]
					<option value="${productCategory.id}"[#if productCategory.id == productCategoryId] selected="selected"[/#if]>
						[#if productCategory.grade != 0]
							[#list 1..productCategory.grade as i]
								&nbsp;&nbsp;
							[/#list]
						[/#if]
						${productCategory.name}
					</option>
				[/#list]
			</select>--]
			<select name="orderStatus">
				<option value="">--订单状态--</option>
				<option value="inited"[#if orderStatus == "inited"] selected[/#if]>未消费</option>
				<option value="completed"[#if orderStatus == "completed"] selected[/#if]>${message("Order.OrderStatus.completed")}</option>
				<option value="cancelled"[#if orderStatus == "cancelled"] selected[/#if]>${message("Order.OrderStatus.cancelled")}</option>
			</select>
			<select name="paymentStatus">
				<option value="">--支付状态--</option>
				<option value="unpaid"[#if paymentStatus == "unpaid"] selected[/#if]>${message("Order.PaymentStatus.unpaid")}</option>
				<option value="paid"[#if paymentStatus == "paid"] selected[/#if]>${message("Order.PaymentStatus.paid")}</option>
			</select>
			<select name="refundStatus">
				<option value="">--退款状态--</option>
				<option value="noRefund"[#if refundStatus == "noRefund"] selected[/#if]>${message("Order.RefundStatus.noRefund")}</option>
				<option value="applied"[#if refundStatus == "applied"] selected[/#if]>${message("Order.RefundStatus.applied")}</option>
				<option value="partialRefunds"[#if refundStatus == "partialRefunds"] selected[/#if]>${message("Order.RefundStatus.partialRefunds")}</option>
				<option value="refunded"[#if refundStatus == "refunded"] selected[/#if]>${message("Order.RefundStatus.refunded")}</option>
			</select>
			[#--<select name="shippingStatus">
				<option value="">--发货状态--</option>
				<option value="unshipped"[#if shippingStatus == "unshipped"] selected[/#if]>${message("Order.ShippingStatus.unshipped")}</option>
				<option value="shipped"[#if shippingStatus == "shipped"] selected[/#if]>${message("Order.ShippingStatus.shipped")}</option>
			</select>--]
			[#--<select name="orderSource">
				<option value="">--订单来源--</option>
				[#list orderSources as os]
				<option value="${os.id}"[#if orderSource == os.id] selected[/#if]>${os.name}</option>
				[/#list]
			</select>--]
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
		</div>
		<div class="bar">
			[@shiro.hasPermission name="admin:addTAOrder"]
			<a href="addBigCustomer.jhtml?isPhaseNote=0" class="button" style="text-align: center;font-size: medium;font-weight: bold;">新建大客户团队订单</a>
			<a href="addBigCustomer.jhtml?isPhaseNote=1" class="button" style="text-align: center;font-size: medium;font-weight: bold;">新建大客户期票订单</a>
			[/@shiro.hasPermission]
			[@shiro.hasPermission name="admin:editTAOrder"]
			<a href="javascript:;"  class="but button">
				${message("admin.common.edit")}
			</a>
			[/@shiro.hasPermission]
			[@shiro.hasPermission name="admin:shippingTaOrder"]
			<a href="javascript:;" class="shippingButton button">发货</a>
			[/@shiro.hasPermission]
			[@shiro.hasPermission name="admin:refundsTaOrder"]
			<a href="javascript:;" class="refundsButton button">退款</a>
			[/@shiro.hasPermission]
			[@shiro.hasPermission name="admin:cancelledTaOrder"]
			<a href="javascript:;" id="cancelledButton" class="button disabled">
				取消
			</a>
			[/@shiro.hasPermission]
			[@shiro.hasPermission name="admin:deleteTaOrder"]
			<a href="javascript:;" id="deleteButton" class="button disabled">
				${message("admin.common.delete")}
			</a>
			[/@shiro.hasPermission]
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="contactName">客户信息</a>
				</th>
				[#--<th>
					<a href="javascript:;" class="sort" name="fullName">产品名称(ID)</a>
				</th>--]
				<th>
					<a href="javascript:;" class="sort" name="sn">订单号</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="quantity">数量</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="totalAmount">总金额</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="paymentStatus">${message("Order.paymentStatus")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="orderStatus">${message("Order.orderStatus")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="syncStatus">同步状态</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="ticketStatus">出票状态</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="checkTicketStatus">检票状态</a>
				</th>
				[#--
				<th>
					<a href="javascript:;" class="sort" name="shippingStatus">发货状态</a>
				</th>
				--]
				<th>
					<a href="javascript:;" class="sort" name="operator">销售人员</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="isPhaseNote">订单类型</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createDate">购买日期</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="date">使用日期</a>
				</th>
				<th>
					<span>${message("admin.common.handle")}</span>
				</th>
			</tr>
			[#assign totalAmount = 0]
			[#assign adultQuantity = 0]
			[#assign childQuantity = 0]
			[#list page.content as order]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${order.id}" />
					</td>
					<td>
						<span title="${order.contactName}">${abbreviate(order.contactName, 8, "...")}
						<br/>${order.contactMobile}</span>
					</td>
					[#--<td>
						<span title="${order.fullName}">
							${abbreviate(order.fullName, 30, "...")}
							(${(order.product.id)})
						</span>
						[#if order.productSource != 'local' && order.paymentStatus='paid']
							[#if order.needSyn && order.synSuccess]
							<span class="synchro_prompt">已同步</span>
							[#elseif order.needSyn && order.orderStatus !='cancelled' && order.refundStatus = 'noRefund']
							<span class="synchro_prompt">
								<a href="javascript:;" onclick="syncOrder(${order.id!});">同步</a>
							</span>
							[/#if]
						[/#if]
					</td>--]
					<td>
						${order.sn}
					</td>
					<td>
						[#list order.orderInfos as orderInfo]
							${orderInfo.fullName}:${orderInfo.quantity}
						[/#list]						
					</td>
					<td>
						[#assign amount = order.totalAmount /]
						[#assign totalAmount = totalAmount+amount]
						${currency(amount)}
					</td>
					<td>
						[#if order.paymentStatus == 'unpaid']
						<font color="red">${message("Order.PaymentStatus." + order.paymentStatus)}</font>
						[#else]
						<font color="green">${message("Order.PaymentStatus." + order.paymentStatus)}</font>
						[/#if]
					</td>
					<td>
						[#if order.orderStatus == 'applied' || order.orderStatus == 'updateApplied' || order.orderStatus == 'cancelled']
							<font color="red">${message("Order.OrderStatus." + order.orderStatus)}</font>
						[#else]
							<font color="green">${message("Order.OrderStatus." + order.orderStatus)}</font>
						[/#if]
					</td>
					<td>
						[#if order.syncStatus]
						<font color="green">已同步</font>
						[#else]
						<font color="red">未同步</font>
						[/#if]
					</td>
					
					<td>
						[#if order.ticketStatus]
						<font color="green">已出票</font>
						[#else]
						<font color="red">未出票</font>
						[/#if]
					</td>
					<td>
						[#if order.checkTicketStatus]
						<font color="green">已检票</font>
						[#else]
						<font color="red">未检票</font>
						[/#if]
					</td>
				
					[#--
					<td>
						[#if order.shippingStatus == 'shipped']
						<font color="green">${order.smsTheme.dealed!'已发货'}</font>
						[#else]
						<font color="red">${order.smsTheme.undeal!'未发货'}</font>
						[/#if]
					</td>
					--]
					<td>
						${order.member.username}
					</td>
					<td>
						[#if order.isPhaseNote]
							期票
						[#else]
							团队
						[/#if]
					</td>
					<td>
						<span title="${order.createDate?string("yyyy-MM-dd HH:mm:ss")}">${order.createDate?string("yyyy-MM-dd")}</span>
					</td>
					<td>
						${(order.date)!}<br/>${order.edate}
					</td>
					<td>
						[@shiro.hasPermission name="admin:viewTAOrder"]
							<a href="view.jhtml?id=${order.id}">[${message("admin.common.view")}]</a>
						[/@shiro.hasPermission]
						
						
						[@shiro.hasPermission name="admin:auditTAOrder"]
							[#if order.orderStatus == 'applied' || order.orderStatus == 'inited' || order.orderStatus == 'updateApplied']
							<br/>
							<a href="javascript:;" class="agreeBtn" data-id="${order.id}">
							[审核通过]
							</a>
							<a href="javascript:;" class="disagreeBtn" data-id="${order.id}"">
							[审核不通过]
							</a>
							[/#if]
						[/@shiro.hasPermission]
						
						[@shiro.lacksRole name="travelagency"]
						[#if order.paymentStatus == 'unpaid']
						<br/>
						<a href="javascript:;" class="paymentButton" data-id="${order.id}" amountPayable="${order.amountPayable}" balance="${order.member.balance}">
						[支付]
						</a>
						[/#if]
						[/@shiro.lacksRole]

						[#if (!order.expired && order.paymentStatus == "paid" && order.orderStatus == "inited" && order.refundStatus != "refunded" && order.refundStatus != "applied")]
							<a class="shippingTrue"></a>
						[#else]
							<a class="shippingFalse"></a>
						[/#if]
						
						[#if (!order.expired && (order.orderStatus == "inited" || order.orderStatus == 'audit') && order.paymentStatus == "paid" && (order.refundStatus == "noRefund" || order.refundStatus == "partialRefunds"))]
							<a class="refundsTrue"></a>
						[#else]
							<a class="refundsFalse"></a>
						[/#if]
					</td>
				</tr>
			[/#list]
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
						${currency(totalAmount)}
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
		[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
			[#include "/admin/include/pagination.ftl"]
		[/@pagination]
	</form>
</body>
</html>
[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.refunds.list")}</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
<script type="text/javascript">
$().ready(function() {

	[@flash_message /]
	
	$(".agreeBtn").click(function(){
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "同意退款？",
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
			content: "不同意退款？",
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
	
	$(".auditBtn").click(function(){
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "请确认此订单是否符合退款条件？",
			ok: "可以退款",
			cancel: "不能退款",
			onOk: function() {
				$.ajax({
					url: "audit.jhtml",
					type: "POST",
					data: {id: $this.attr("data-id"),flag:1},
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
			},
			onCancel: function() {
				$.ajax({
					url: "audit.jhtml",
					type: "POST",
					data: {id: $this.attr("data-id"),flag:0},
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

});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			${message("admin.refunds.list")} 
	    </div>
	</div>
	<form id="listForm" action="list.jhtml" method="get">
		<div class="bar">
			<select name="state">
				<option value="">--退款单状态--</option>
				[#list states as s]
				<option value="${s}"[#if state == s] selected[/#if]>${message("Refunds.State."+s)}</option>
				[/#list]
			</select>
			<select name="orderSource">
				<option value="">--订单来源--</option>
				[#list orderSources as os]
				<option value="${os.id}"[#if orderSource == os.id] selected[/#if]>${os.name}</option>
				[/#list]
			</select>
			<input type="text" name="productName" placeholder="产品名称" value="${productName}" />
			<input type="text" name="orderSn" placeholder="订单编号" value="${orderSn}" />
			<input type="text" name="seller" placeholder="销售人员" value="${seller}" />
			<input id="startDate" type="text" class="text Wdate" name="startDate" onclick="WdatePicker()" placeholder="退款时间起" value="${startDate}"/>
			<input id="endDate" type="text" class="text Wdate" name="endDate" onclick="WdatePicker({minDate: '#F{$dp.$D(\'startDate\')}'})" placeholder="退款时间止" value="${endDate}"/>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
		</div>
		<div class="bar">
			<@shiro.hasPermission name = "admin:deleteRefunds"]
				<a href="javascript:;" id="deleteButton" class="button">
					${message("admin.common.delete")}
				</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:exportRefunds"]
			<a href="list.jhtml?${queryString}&op=export" class="button">导出</a>
			</@shiro.hasPermission>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="orderSn">订单编号</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="method">${message("Refunds.method")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="operator">申请人</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createDate">申请时间</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="modifyDate">退款时间</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="contactName">姓名</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="contactMobile">联系电话</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="productName">产品名称</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="quantity">退款数量</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="amount">${message("Refunds.amount")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="state">退款状态</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="memo">备注</a>
				</th>
				<th>
					<span>${message("admin.common.handle")}</span>
				</th>
			</tr>
			[#assign totalQuantity = 0]
			[#assign totalAmount = 0]
			[#list page.content as refunds]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${refunds.id}" />
					</td>
					<td>
						<a href="../order/view.jhtml?id=${refunds.order.id}">${refunds.orderSn}</a>
					</td>
					<td>
						${message("Refunds.Method." + refunds.method)}
					</td>
					<td>
						${refunds.operator}
					</td>
					<td>
						<span title="${refunds.createDate?string("yyyy-MM-dd HH:mm:ss")}">${refunds.createDate?string("yyyy-MM-dd")}</span>
					</td>
					<td>
						<span title="${refunds.modifyDate?string("yyyy-MM-dd HH:mm:ss")}">${refunds.modifyDate?string("yyyy-MM-dd")}</span>
					</td>
					<td>
						${refunds.contactName}
					</td>
					<td>
						${refunds.contactMobile}
					</td>
					<td>
						<span title="${refunds.productName}">
							${abbreviate(refunds.productName, 30, "...")}
						</span>
					</td>
					<td>
						${refunds.quantity}
					</td>
					<td>
						[#assign amount = refunds.amount/]
						[@shiro.hasRole name="supplier"]
							[#assign amount = refunds.order.authPrice*refunds.quantity*refunds.order.unit /]
						[/@shiro.hasRole]
						[@shiro.lacksRole name="supplier"]
							[#list refunds.order.orderPrices as price]
								[#if price.member == member]
								[#assign amount = price.price*refunds.quantity*refunds.order.unit/]
								[#break/]
								[/#if]
							[/#list]
						[/@shiro.lacksRole]
						${currency(amount)}
					</td>
					[#assign totalQuantity = totalQuantity+refunds.quantity]
					[#assign totalAmount = totalAmount+amount]
					<td>
						[#if refunds.state == 'agree']
						<font color="green">${message("Refunds.State." + refunds.state)}</font>
						[#else]
						<font color="red">${message("Refunds.State." + refunds.state)}</font>
						[/#if]
					</td>
					<td>
						[#if refunds.memo??]
						<span title="${refunds.memo}">有</span>
						[#else]
						无
						[/#if]
					</td>
					<td>
						<a href="view.jhtml?id=${refunds.id}">[${message("admin.common.view")}]</a>
						<@shiro.hasPermission name = "admin:dealRefunds"]
						[#if refunds.state == 'apply']
						<a href="javascript:;" class="agreeBtn" data-id="${refunds.id}">同意</a>
						<a href="javascript:;" class="disagreeBtn" data-id="${refunds.id}">不同意</a>
						[/#if]
						</@shiro.hasPermission>
						<@shiro.hasPermission name = "admin:auditRefunds"]
						[#if refunds.state == 'audit']
						<a href="javascript:;" class="auditBtn" data-id="${refunds.id}">审核退款</a>
						[/#if]
						</@shiro.hasPermission>
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
					${totalQuantity}
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
			</tr>
		</table>
		[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
			[#include "/admin/include/pagination.ftl"]
		[/@pagination]
	</form>
</body>
</html>
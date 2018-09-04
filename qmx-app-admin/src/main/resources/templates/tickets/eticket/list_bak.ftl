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
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap-paginator.js"></script>
<script type="text/javascript">
$().ready(function() {
	
	$("#settle").click(function(){
		var $this = $(this);
		/*if ($this.hasClass("disabled")) {
			return false;
		}*/
		var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
		
		if($checkedIds.length == 0){
			alert("你还未选中记录");
			return false;
		}
		
		$.dialog({
			type: "warn",
			content: "确认要结算吗？",
			ok: "admin.dialog.ok",
			cancel: "admin.dialog.cancel",
			onOk: function() {
				$.ajax({
					url: "settle.jhtml",
					type: "POST",
					data: $checkedIds.serialize(),
					dataType: "json",
					cache: false,
					success: function(message) {
						$.message(message);
						if (message.type == "success") {
							setTimeout(function() {
								location.reload(true);
							}, 1000);
						}
					}
				});
			}
		});
	});

    $("#consumeTicket").click(function(){
        var browserFrameId = "browserFrame" + (new Date()).valueOf() + Math.floor(Math.random() * 1000000);
        var $browser = $('<div class="xxBrowser" style="height:380px;"><\/div>');
        $browserFrame = $('<iframe id="' + browserFrameId + '" name="' + browserFrameId + '" src="queryEticketList?q='+$("input[name=q]").val()+'" style="width:100%; height:100%;" frameborder="0"><\/iframe>').appendTo($browser);
        var $dialog = $.dialog({
            title: "验证电子票（<font color='red'>注:支付方式为【到店支付】的电子票必须付款后才能验证</font>）",
            content: $browser,
            width: 850,
            modal: true,
            ok: "确定消费",
            cancel: "关闭",
            onOk: function() {
                $(window.frames[browserFrameId].document).find("form").submit();
                return false;
            },
            onCancel: function() {
                //location.reload(true)
            }
        });
    });

});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			电子票列表 
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<input type="text" name="contactName" value="${queryDto.contactName!}" placeholder="客户姓名" />
			<input type="text" name="mobileOrSn" value="${queryDto.mobileOrSn!}" placeholder="电子票/手机号码" />
			<input type="text" name="productSn" value="${queryDto.productSn!}" placeholder="产品ID" />
			<input type="text" name="orderSn" value="${queryDto.orderSn!}" placeholder="订单编号" />
			<input type="text" name="seller" value="${queryDto.seller!}" placeholder="销售人员账号" />
			<input type="text" name="supplier" value="${queryDto.supplier!}" placeholder="供应商账号" />
			<input type="text" name="checker" value="${queryDto.checker!}" placeholder="验票人账号" />
			<br/>
			<select name="orderSource">
				<option value="">--订单来源--</option>
				<#--<#list orderSources as os>
				<option value="${os.id}"<#if orderSource == os.id> selected</#if>>${os.name}</option>
				</#list>-->
			</select>
			<select name="settle">
				<option value="">--是否结算--</option>
				<option value="true"<#if queryDto.settle?? && queryDto.settle == "true"> selected</#if>>已结算</option>
				<option value="false"<#if queryDto.settle?? && queryDto.settle == "false"> selected</#if>>未结算</option>
			</select>
			<select name="state">
				<option value="">--是否失效--</option>
				<option value="ok"<#if queryDto.settle?? && queryDto.state == "ok"> selected</#if>>正常</option>
				<option value="cancel"<#if queryDto.settle?? && queryDto.state == "cancel"> selected</#if>>失效</option>
			</select>
			<select name="useState">
				<option value="">--是否使用--</option>
				<option value="true"<#if queryDto.useState?? && queryDto.useState == "true"> selected</#if>>已使用</option>
				<option value="false"<#if queryDto.useState?? && queryDto.useState == "false"> selected</#if>>未使用</option>
			</select>
			<input id="startDate" type="text" class="text Wdate" name="startDate" onclick="WdatePicker()" placeholder="消费时间起" value="${queryDto.startDate!}"/>
			<input id="endDate" type="text" class="text Wdate" name="endDate" onclick="WdatePicker({minDate: '#F{$dp.$D(\'startDate\')}'})" placeholder="消费时间止" value="${queryDto.endDate!}"/>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
		</div>
        <div class="bar">
            <input type="text" name="q" class="" value="" maxlength="20" placeholder="电子票/手机号码" />
            <a href="javascript:;" id="consumeTicket" class="button">查询电子票</a>
        </div>
		<div class="bar">
			<@shiro.hasPermission name = "admin:eticketDelete">
			<a href="javascript:;" id="deleteButton" class="button">
				${message("admin.common.delete")}
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:eticketExport">
			<a href="list.jhtml?${queryString}&op=export" class="button">
				导出
			</a>
			</@shiro.hasPermission>
			<@shiro.hasPermission name = "admin:eticketSettle">
			<a id="settle" href="javascript:;" class="button">
				结算
			</a>
			</@shiro.hasPermission>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="customerName">姓名(联系方式)</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="sn">电子票</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="product">购买产品(产品ID)</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="settlePrice">结算价格</a>
				</th>
				<#--
				<th>
					<a href="javascript:;" class="sort" name="price">销售价格</a>
				</th>
				-->
				<th>
					<a href="javascript:;" class="sort" name="supplier">供应商</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="member">销售人员</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createDate">购买日期</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="useDate">消费日期</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="useState">使用状态</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="state">是否有效</a>
				</th>
				<th>
					检票方式
				</th>
				<th>
					<a href="javascript:;" class="sort" name="operator">验票人</a>
				</th>
				<!-- 
				<th>
					<a href="javascript:;" class="sort" name="isSettle">是否结算</a>
				</th>
				 -->
			</tr>
			<#list page.records as ad>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${ad.id}" />
					</td>
					<td>
						${ad.customerName!}(${ad.contactMobile!})
					</td>
					<td>
						${ad.sn}
					</td>
					<td>
						<span title="${ad.productName}">
							${ad.productName!}
						</span>
						(${ad.productId!})
					</td>
					<td>
						<@shiro.hasRole name="supplier">
							<#assign price = ad.settlePrice />
						</@shiro.hasRole>
						<@shiro.lacksRole name="supplier">
							<#--
							<#if ad.order.orderPrices?size == 0>
							<#assign price = ad.settlePrice/>
							<#else>
							<#assign price = ad.order.orderPrices[0].settlePrice/>
							</#if>
							-->
							<#assign price = ad.distPrice />
						</@shiro.lacksRole>
						${price!}
					</td>
					<#--
					<td>
						${currency(ad.price)}
					</td>
					-->
					<td>
						${ad.supplier.username}
					</td>
					<td>
						<#if ad.supplier2?? && admin=ad.supplier2>
						${ad.supplier.username}
						<#else>
						${ad.member.username}
						</#if>
					</td>
					<td>
						<span title="${ad.createTime?datetime}">${ad.createTime?datetime}</span>
					</td>
					<td>
						<span title="${(ad.useDate?datetime)!}">${(ad.useDate?datetime)!}</span>
					</td>
					<td>
						${ad.useState?string('<font color="red">已使用</font>','未使用')}
					</td>
					<td>
						<#if ad.state??>
							<#if ad.state != 'NORMAL'>
                                <font color="red">${ad.state.getName()}</font>
							<#else>
							${ad.state.getName()}
							</#if>
						<#else>
							-
						</#if>

					</td>
					<td>
						<#if ad.consumeType??>
							${ad.consumeType.getName()}
						</#if>
					</td>
					<td>
						<#if ad.checkUser??>
						    ${ad.checkUser.username}
						    <#else>
							无检票员
						</#if>
					</td>
					<!-- 
					<td>
						${ad.settle?string('<font color="red">已结算</font>','未结算')}
					</td>
					 -->
				</tr>
			</#list>
		</table>
			<#include "/include/pagination.ftl">
	</form>
</body>
</html>
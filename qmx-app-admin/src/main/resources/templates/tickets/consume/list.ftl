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
<script type="text/javascript">
$().ready(function() {

	[@flash_message /]
	
	$("#consumeTicket").click(function(){
		var browserFrameId = "browserFrame" + (new Date()).valueOf() + Math.floor(Math.random() * 1000000);
		var $browser = $('<div class="xxBrowser" style="height:380px;"><\/div>');
		$browserFrame = $('<iframe id="' + browserFrameId + '" name="' + browserFrameId + '" src="queryEticket.jhtml?q='+$("input[name=q]").val()+'" style="width:100%; height:100%;" frameborder="0"><\/iframe>').appendTo($browser);
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
	<div class="path">
		消费验证 
	</div>
	<form id="listForm" action="list.jhtml" method="get">
		<div class="bar">
			<input type="text" name="contactName" value="${contactName}" placeholder="客户姓名" />
			<input type="text" name="mobileOrSn" value="${mobileOrSn}" placeholder="电子票/手机号码" />
			<input type="text" name="productSn" value="${productSn}" placeholder="产品ID" />
			<input type="text" name="orderSn" value="${orderSn}" placeholder="订单编号" />
			<input type="text" name="seller" value="${seller}" placeholder="销售人员" />
			<select name="isSettle">
				<option value="">--是否结款--</option>
				<option value="true"[#if isSettle == "true"] selected[/#if]>已结款</option>
				<option value="false"[#if isSettle == "false"] selected[/#if]>未结款</option>
			</select>
			<select name="state">
				<option value="">--是否失效--</option>
				<option value="ok"[#if state == "ok"] selected[/#if]>${message("Eticket.State.ok")}</option>
				<option value="cancel"[#if state == "cancel"] selected[/#if]>${message("Eticket.State.cancel")}</option>
			</select>
			<input id="startDate" type="text" class="text Wdate" name="startDate" onclick="WdatePicker()" placeholder="消费时间起" value="${startDate}"/>
			<input id="endDate" type="text" class="text Wdate" name="endDate" onclick="WdatePicker({minDate: '#F{$dp.$D(\'startDate\')}'})" placeholder="消费时间止" value="${endDate}"/>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
			<div class="buttonWrap">
			</div>
		</div>
		<div class="bar">
			<input type="text" name="q" class="" value="" maxlength="20" placeholder="电子票/手机号码" />
			<a href="javascript:;" id="consumeTicket" class="button">验证电子票</a>
			<a href="list.jhtml?${queryString}&op=export" class="button">
				导出
			</a>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="mobile">联系方式</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="customerName">顾客姓名</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="sn">电子票</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="product">购买产品(产品ID)</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="supplier">供应商</a>
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
					<a href="javascript:;" class="sort" name="operator">验票人</a>
				</th>
			</tr>
			[#list page.content as ad]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${ad.id}" />
					</td>
					<td>
						${ad.mobile}
					</td>
					<td>
						${ad.customerName}
					</td>
					<td>
						${ad.sn}
					</td>
					<td>
						<span title="${ad.product.fullName}">
							${abbreviate(ad.product.fullName, 30, "...")}
						</span>
						(${ad.product.id})
					</td>
					<td>
						${ad.supplier.username}
					</td>
					<td>
						<span title="${ad.createDate?string("yyyy-MM-dd HH:mm:ss")}">${ad.createDate?string("yyyy-MM-dd")}</span>
					</td>
					<td>
						<span title="${ad.useDate?string("yyyy-MM-dd HH:mm:ss")}">${ad.useDate?string("yyyy-MM-dd")}</span>
					</td>
					<td>
						${ad.useState?string('<font color="red">已使用</font>','未使用')}
					</td>
					<td>
						[#if ad.state != 'ok']
						<font color="red">${message("Eticket.State."+ad.state)}</font>
						[#else]
						${message("Eticket.State."+ad.state)}
						[/#if]
					</td>
					<td>
						${ad.operator.username}
					</td>
				</tr>
			[/#list]
		</table>
		[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
			[#include "/admin/include/pagination.ftl"]
		[/@pagination]
	</form>
</body>
</html>
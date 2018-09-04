<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>库存列表信息</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
	<script type="text/javascript" src="${base}/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap-paginator.js"></script>
<script type="text/javascript">
$().ready(function() {

});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			库存列表
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<input type="text" name="skuName" value="${queryVo.skuName!}" placeholder="库存名称" />
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
		</div>
		<div class="bar">
			<@shiro.hasPermission name = "admin:addTicketStock">
			<a href="add" class="button">
				添加
			</a>
			</@shiro.hasPermission>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					skuId
				</th>
                <th>
                    库存日期
                </th>
				<th>
					库存名称
				</th>
				<th>库存数量</th>
                <th>已售数量</th>
				<th>
					添加时间
				</th>
				<th>
					<span>操作</span>
				</th>
			</tr>
			<#list page.records as stock>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${stock.id}" />
					</td>
					<td>
						${stock.skuId!}
					</td>
                    <td>
					${stock.skuDate!}
                    </td>
					<td>
						${stock.skuName!}
					</td>
					<td>${stock.stockNum!}</td>
                    <td>${stock.sells!}</td>
					<td>
						${stock.createTime?datetime}
					</td>
					<td>
						<@shiro.hasPermission name = "admin:editTicketStock">
						<a href="edit?id=${stock.id}">[编辑]</a>
						</@shiro.hasPermission>
						<@shiro.hasPermission name = "admin:deleteTicketStock">
                            <a href="delete?id=${stock.id}">[删除]</a>
						</@shiro.hasPermission>
					</td>
				</tr>
			</#list>
		</table>
	<#include "/include/pagination.ftl">
	</form>
</body>
</html>
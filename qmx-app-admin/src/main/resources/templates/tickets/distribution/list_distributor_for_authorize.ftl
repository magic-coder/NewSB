<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>分销列表</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/bootstrap-paginator.js"></script>
<script type="text/javascript">
$().ready(function() {

});
</script>
</head>
<body>
	<form id="listForm" action="listDistributorForAuthorize.jhtml" method="get">
		<div class="bar">
			<div class="menuWrap">
				<select name="searchProperty">
					<option value="username" selected>用户名</option>
				</select>
					<input type="text" id="searchValue" name="searchValue" value="${queryDto.name!}" maxlength="200" />
			</div>
			<button type="submit" class="button">查询</button>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					账号
				</th>
				<th>
					角色
				</th>
				<th>
					用户名
				</th>
				<th>
					状态
				</th>
				<th>
					添加时间
				</th>
			</tr>
			<#list page.records as admin>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${admin.id}" />
					</td>
					<td>
						${admin.account}
					</td>
					<td>
						${admin.userType.getName()}
					</td>
					<td>
						${admin.username}
					</td>
					<td>
						<#if !admin.enable>
							<span class="red">禁用</span>
						<#elseif admin.locked>
							<span class="red">锁定</span>
						<#else>
							<span class="green">正常</span>
						</#if>
					</td>
					<td>
						<span title="${admin.createTime?datetime}">${admin.createTime?datetime}</span>
					</td>
				</tr>
			</#list>
		</table>
		<#include "/include/pagination.ftl"/>
	</form>
</body>
</html>
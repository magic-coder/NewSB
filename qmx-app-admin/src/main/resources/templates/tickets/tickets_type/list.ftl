<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>票型列表</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			票型名称：<input type="text" id="searchValue" name="name" value="${queryVO.name!}" maxlength="200" />
			<button type="submit" class="button">查询</button>
		</div>
        <div class="bar">
		<@shiro.hasPermission name = "admin:addTicketsType">
            <a href="addTicketsType" class="button">
                新建票型
            </a>
		</@shiro.hasPermission>
        </div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
                <th>
                    票型名称
                </th>
				<th>
					景区名称
				</th>
				<th>
					所属供应商
				</th>
				<th>
					添加时间
				</th>
                <th>
                    操作
                </th>
			</tr>
			<#list page.records as dto>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${dto.id}" />
					</td>
                    <td>
						${dto.name!}
                    </td>
					<td>
						${dto.sightName}
					</td>
					<td>
						${dto.supplierAccount!}
					</td>
					<td>
						<span title="${dto.createTime?datetime}">${dto.createTime?datetime}</span>
					</td>
                    <td>
						<@shiro.hasPermission name = "admin:updateTicketsType">
                            <a href="editTicketsType?id=${dto.id}">编辑</a>
						</@shiro.hasPermission>
						<@shiro.hasPermission name = "admin:deleteTicketsType">
                            <a href="deleteTicketsType?id=${dto.id}">编辑</a>
						</@shiro.hasPermission>
                    </td>
				</tr>
			</#list>
		</table>
			<#include "/include/pagination.ftl">
	</form>
</body>
</html>
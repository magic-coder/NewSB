<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>字典列表</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			字典列表 
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
		<@shiro.hasPermission name = "admin:addDict">
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
					名称
				</th>
				<th>
					code
				</th>
                <th>
                    类型
                </th>
				<th>
					排序
				</th>
                <th>
                    是否可编辑
                </th>
				<th>
					<span>操作</span>
				</th>
			</tr>
			<#list page.records as dto>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${dto.id}" />
					</td>
					<td>
						${dto.codeText!}
					</td>
					<td>
						${dto.code!}
					</td>
                    <td>
					${dto.type!}
                    </td>
					<td>
						${dto.sortNo}
					</td>
                    <td>
                        <span class="${dto.editable?string("true", "false")}Icon">&nbsp;</span>
                    </td>
					<td>
						<@shiro.hasPermission name = "admin:updateDict">
                            <a href="edit.jhtml?id=${dto.id}">[编辑]</a>
						</@shiro.hasPermission>
					</td>
				</tr>
			</#list>
		</table>
	<#include "/include/pagination.ftl">
	</form>
</body>
</html>
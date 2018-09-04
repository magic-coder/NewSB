<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>订阅信息列表</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			订阅信息列表
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
        <div class="bar">
            tag:
            <select name="tag">
                <option value="">请选择</option>
				<#list tags as tag>
                    <option value="${tag}" <#if queryDto.tag?? && queryDto.tag = tag>selected</#if>>${tag.getName()!}</option>
				</#list>
            </select>
			<input type="text" name="tag" value="${queryDto.tag!}"/>
            <input type="submit" class="button" value="查询"/>
        </div>
		<div class="bar">
		<@shiro.hasPermission name = "admin:addMQSubscription">
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
					订阅tag
				</th>
				<th>
					url
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
						${dto.tag.getName()!}(${dto.tag!})
					</td>
					<td>
						${dto.url!}
					</td>
					<td>
						<@shiro.hasPermission name = "admin:updateMQSubscription">
                            <a href="edit?id=${dto.id}">[编辑]</a>
						</@shiro.hasPermission>
						<@shiro.hasPermission name = "admin:deleteMQSubscription">
                            <a href="delete?id=${dto.id}">[删除]</a>
						</@shiro.hasPermission>
					</td>
				</tr>
			</#list>
		</table>
	<#include "/include/pagination.ftl">
	</form>
</body>
</html>
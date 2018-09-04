<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>列表</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			模块列表
	    </div>
	</div>
	<form id="listForm" action="list.jhtml" method="get">
		<div class="bar">
			<br/>
			<input type="text" placeholder="模块名称" id="searchValue" value="${(dto.moduleName)!}" name="moduleName" maxlength="200" />
			<input name="appKey" placeholder="appKey" value="${(dto.appKey)!}" />
			<input name="appSecret" placeholder="appSecret" value="${(dto.appSecret)!}" />
            <select name="enable">
                <option value="">--是否启用--</option>
                <option <#if dto?? && dto.enable?? && dto.enable>selected</#if> value="true">启用</option>
                <option <#if dto?? && dto.enable?? && !dto.enable>selected</#if> value="false">禁用</option>
            </select>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
			<span style="color:green;">${flash_message_attribute_name!}</span>
		</div>
		<div class="bar">
			&nbsp;
		<@shiro.hasPermission name = "admin:addModule">
            <a href="add" class="button">
                添加模块
            </a>
		</@shiro.hasPermission>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					模块id
				</th>
				<th>
					模块名称
				</th>
				<th>
					模块账号
				</th>
				<th>
					模块密码
				</th>
                <th>
                    是否是基本模块
                </th>
				<th>排序</th>
				<th>
					是否启用
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
					${dto.id}
                    </td>
					<td>
						${dto.moduleName}
					</td>
					<td>
						${dto.appKey}
					</td>
					<td>
						${dto.appSecret}
					</td>
                    <td>
                        <span class="${dto.basic?string("true", "false")}Icon">&nbsp;</span>
                    </td>
					<td>
						${dto.sortNo!}
					</td>
					<td>
                        <span class="${dto.enable?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
						<@shiro.hasPermission name = "admin:updateModule">
                            <a href="edit?id=${dto.id}">[编辑]</a>
						</@shiro.hasPermission>
						<@shiro.hasPermission name = "admin:deleteModule">
                            <a class="del" url="delete?id=${dto.id}">[删除]</a>
						</@shiro.hasPermission>
					</td>
				</tr>
			</#list>
		</table>
			<#include "/include/pagination.ftl">
	</form>
</body>
<script type="text/javascript">
    $(function () {
        $(".del").click(function () {
            var flag = window.confirm("确定删除？");
            if(flag == true){
                var url = $(this).attr("url");
                location.href = url;
            }
        });
    })
</script>
</html>
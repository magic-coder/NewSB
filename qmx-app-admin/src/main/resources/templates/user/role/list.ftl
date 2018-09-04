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
			角色列表
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<br/>
			<input type="text" placeholder="角色名称" value="${(roleQueryVo.roleName)!}" name="roleName" maxlength="200" />
			<input type="text" placeholder="角色编码" value="${(roleQueryVo.code)!}" name="code"/>
			<input type="text" placeholder="所属人" value="${(roleQueryVo.memberAccount)!}" name="memberAccount"/>
            <select name="sys">
                <option value="">--是否系统内置--</option>
                <option <#if roleQueryVo?? && roleQueryVo.sys?? && roleQueryVo.sys>selected</#if> value="true">是</option>
                <option <#if roleQueryVo?? && roleQueryVo.sys?? && !roleQueryVo.sys>selected</#if> value="false">否</option>
            </select>
            <select name="enable">
                <option value="">--是否启用--</option>
                <option <#if roleQueryVo?? && roleQueryVo.enable?? && roleQueryVo.enable>selected</#if> value="true">启用</option>
                <option <#if roleQueryVo?? && roleQueryVo.enable?? && !roleQueryVo.enable>selected</#if> value="false">禁用</option>
            </select>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
			<span style="color:green;">${flash_message_attribute_name!}</span>
		</div>
		<div class="bar">
			&nbsp;
			<@shiro.hasPermission name = "admin:addRole">
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
					角色编码
				</th>
				<th>
					角色名称
				</th>
				<th>是否内置</th>
				<th>
					排序
				</th>
				<th>备注</th>
				<th>添加时间</th>
				<th>所属人</th>
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
					${dto.code!}
						<#if dto.supplierRecommend??>
                            ${dto.supplierRecommend?string("[供应商推荐角色]","")}
						</#if>
                    </td>
					<td>
						${dto.roleName!}[${dto.userType.getName()!}]${dto.recommend?string("[推荐角色]","")}
					</td>
					<td>${dto.sys?string("是", "否")}</td>
					<td>
						${dto.sortNo!}
					</td>
					<td>${dto.remark!}</td>
					<td>${(dto.createTime?string("yyyy-MM-dd HH:mm:ss"))!'-'}</td>
					<td>${(dto.memberAccount)!'-'}</td>
					<td>
                        <span class="${dto.enable?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
						<@shiro.hasPermission name = "admin:updateRole">
                            <a href="edit?id=${dto.id}">[编辑]</a>
						</@shiro.hasPermission>
						<@shiro.hasPermission name = "admin:deleteRole">
                            <a class="del" url="delete?id=${dto.id}">[删除]</a>
						</@shiro.hasPermission>
						<@shiro.hasPermission name = "admin:editRolePermission">
                            <a href="editRolePermission?id=${dto.id}">[编辑权限]</a>
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
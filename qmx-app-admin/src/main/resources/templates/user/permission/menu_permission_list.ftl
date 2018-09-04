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
			菜单权限列表
	    </div>
	</div>
	<form id="listForm" action="menuPermissionList?menuId=${menuInfo.id!}" method="get">
        <div class="bar">
            菜单名称：${menuInfo.menuName!}
        </div>
		<div class="bar">
			&nbsp;
			<a href="add?menuId=${menuInfo.id!}" class="button">
				添加权限
			</a>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					权限编码
				</th>
				<th>
					权限名称
				</th>
				<th>标签id</th>
				<th>权限类型</th>
				<th>
					排序
				</th>
				<th>备注</th>
				<th>添加时间</th>
				<th>
					是否启用
				</th>
				<th>
					<span>操作</span>
				</th>
			</tr>
			<#list permissions as dto>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${dto.id}" />
					</td>
                    <td>
					${dto.permission}
                    </td>
					<td>
						${dto.permissionName!}
					</td>
					<td>${dto.labelId!}</td>
					<td>
					<#if dto.permissionType??>
					    <#if dto.permissionType == 0>
							列表权限
						<#elseif dto.permissionType == 1>
                            单个操作权限
						<#else>
							其他
						</#if>
					</#if>
					</td>
					<td>
						${dto.sortNo!}
					</td>
					<td>${dto.remark!}</td>
					<td>${(dto.createTime?string("yyyy-MM-dd HH:mm:ss"))!'-'}</td>
					<td>
                        <span class="${dto.enable?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>
                        <a href="edit?id=${dto.id}">[编辑]</a>
						<a class="del" url="delete?id=${dto.id}&menuId=${menuInfo.id!}">[删除]</a>
					</td>
				</tr>
			</#list>
		</table>
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
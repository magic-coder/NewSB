[#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"] /]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>${message("admin.admin.list")}</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
<script type="text/javascript">
$().ready(function() {
	
	[@flash_message /]
	$(".disabled").click(function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "确定要禁用此账号吗？",
			onOk: function() {
				$.ajax({
					url: $this.attr("url"),
					type: "POST",
					cache: false,
					success: function(message) {
						$.message(message);
						if (message.type == "success") {
							location.reload(true);
						}
					}
				});
			}
		});
		return false;
	});
	
	$(".enabled").click(function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "确定要启用此账号吗？",
			onOk: function() {
				$.ajax({
					url: $this.attr("url"),
					type: "POST",
					cache: false,
					success: function(message) {
						$.message(message);
						if (message.type == "success") {
							location.reload(true);
						}
					}
				});
			}
		});
		return false;
	});

});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			分销商列表 
	    </div>
	</div>
	<form id="listForm" action="list.jhtml" method="get">
		<div class="bar">
			<div class="menuWrap">
				<select name="searchProperty">
					<option value="username"[#if page.searchProperty == "username"] selected[/#if]>${message("Admin.username")}</option>
					<option value="email"[#if page.searchProperty == "email"] selected[/#if]>${message("Admin.email")}</option>
					<option value="name"[#if page.searchProperty == "name"] selected[/#if]>${message("Admin.name")}</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${page.searchValue}" maxlength="200" />
			</div>
			<select name="isEnabled">
				<option value="">--是否启用--</option>
				<option value="true"[#if isEnabled?? && isEnabled ='true'] selected[/#if]>启用</option>
				<option value="false"[#if isEnabled?? && isEnabled ='false'] selected[/#if]>禁用</option>
			</select>
			<select name="isLocked">
				<option value="">--是否锁定--</option>
				<option value="true"[#if isLocked?? && isLocked ='true'] selected[/#if]>已锁定</option>
				<option value="false"[#if isLocked?? && isLocked ='false'] selected[/#if]>未锁定</option>
			</select>
			<select name="apiPlat">
				<option value="">--分销类型--</option>
				<option value="true"[#if apiPlat?? && apiPlat ='true'] selected[/#if]>接口分销</option>
				<option value="false"[#if apiPlat?? && apiPlat ='false'] selected[/#if]>普通分销</option>
			</select>
			<input name="creator" placeholder="创建人账号" value="${creator}" />
			<input name="member" placeholder="所属人账号" value="${member}" />
			<input name="areaName" placeholder="地区" value="${areaName}" />
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
		</div>
		<div class="bar">
			<@shiro.hasPermission name = "admin:addDistributor"]
			<a href="add.jhtml" class="button">
				添加普通分销
			</a>
			<a href="add.jhtml?fg=_ota" class="button">
				添加OTA分销
			</a>
			</@shiro.hasPermission>
				<@shiro.hasPermission name = "admin:deleteDistributor"]
				<a href="javascript:;" id="deleteButton" class="button">
					${message("admin.common.delete")}
				</a>
				</@shiro.hasPermission>
			[#--
			<@shiro.hasPermission name = "admin:exportDistributor"]
				<a href="list.jhtml?${queryString}&op=export" class="button">导出</a>
			</@shiro.hasPermission>
			--]
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					用户名（账号）
				</th>
				
				<th>
					<a href="javascript:;" class="sort" name="mobile">手机号码</a>
				</th>
				<th>
					关联接口
				</th>
				<th>
					<a href="javascript:;" class="sort" name="area">地区</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="loginDate">${message("Admin.loginDate")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="createDate">${message("admin.common.createDate")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="operator">创建人</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="isEnabled">${message("admin.admin.status")}</a>
				</th>
				<th>
					<span>${message("admin.common.handle")}</span>
				</th>
			</tr>
			[#list page.content as admin]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${admin.id}" />
					</td>
					<td>
						<span title="${admin.name}">
							${abbreviate(admin.name, 20, "...")}（${admin.username}）
						</span>
					</td>
					<td>
						[@shiro.hasRole name="supplier"]
						[#if admin.member.role == 'distributor']
							-
						[#else]
						${admin.mobile}
						[/#if]
						[/@shiro.hasRole]
						[@shiro.lacksRole name="supplier"]
						${admin.mobile}
						[/@shiro.lacksRole]
					</td>
					<td>
						[#if admin.apiPlat??]
						${admin.apiPlat.caption}
						[#else]
						-
						[/#if]
					</td>
					<td>
						${admin.area.fullName}
					</td>
					<td>
						[#if admin.loginDate??]
							<span title="${admin.loginDate?string("yyyy-MM-dd HH:mm:ss")}">${admin.loginDate}</span>
						[#else]
							-
						[/#if]
					</td>
					<td>
						<span title="${admin.createDate?string("yyyy-MM-dd HH:mm:ss")}">${admin.createDate}</span>
					</td>
					<td>
						${admin.operator.username}
					</td>
					<td>
						[#if !admin.isEnabled]
							<span class="red">${message("admin.admin.disabled")}</span>
						[#elseif admin.isLocked]
							<span class="red"> ${message("admin.admin.locked")} </span>
						[#else]
							<span class="green">${message("admin.admin.normal")}</span>
						[/#if]
					</td>
					<td>
						<a href="../admin/view.jhtml?id=${admin.id}">[查看]</a>
						<@shiro.hasPermission name = "admin:editDistributor"]
						
						[@shiro.hasRole name = "manager"]
						[#assign flag = '&fg=_ota']
						[/@shiro.hasRole]
						<a href="edit.jhtml?id=${admin.id}[#if admin.apiPlat??]${flag}[/#if]">[${message("admin.common.edit")}]</a>
						[#if admin.isEnabled]
						<a href="javascript:;" url="disabled.jhtml?id=${admin.id}" class="disabled">[禁用]</a>
						[#else]
						<a href="javascript:;" url="enabled.jhtml?id=${admin.id}" class="enabled">[启用]</a>
						[/#if]
						</@shiro.hasPermission>
						
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
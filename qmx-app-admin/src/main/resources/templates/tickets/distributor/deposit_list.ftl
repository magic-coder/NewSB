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
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			分销商列表 
	    </div>
	</div>
	<form id="listForm" action="depositList.jhtml" method="get">
		<div class="bar">
			<div class="menuWrap">
				<select name="searchProperty">
					<option value="username"[#if page.searchProperty == "username"] selected[/#if]>${message("Admin.username")}</option>
					<option value="email"[#if page.searchProperty == "email"] selected[/#if]>${message("Admin.email")}</option>
					<option value="name"[#if page.searchProperty == "name"] selected[/#if]>${message("Admin.name")}</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${page.searchValue}" maxlength="200" />
			</div>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					<a href="javascript:;" class="sort" name="username">${message("Admin.username")}</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="name">名称</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="mobile">手机号码</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="balance">预存款余额</a>
				</th>
				<th>
					<a href="javascript:;" class="sort" name="isEnabled">${message("admin.admin.status")}</a>
				</th>
				<th>
					<span>${message("admin.common.handle")}</span>
				</th>
			</tr>
			[#list page.content as o]
			[#assign admin=o.a/]
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${admin.id}" />
					</td>
					<td>
						<span title="${admin.username}" style="margin-left: ${o.depth * 30}px;">
						${admin.username}
						</span>
					</td>
					<td>
						<span title="${admin.name}">
							${abbreviate(admin.name, 20, "...")}
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
						${currency(admin.balance)}
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
						<@shiro.hasPermission name = "admin:rechargeDistributor"]
						<a href="recharge.jhtml?id=${admin.id}">[修改预存款]</a>
						</@shiro.hasPermission>
						<a href="../report2/queryDeposit?memberId=${admin.id}">[预存款明细统计]</a>
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
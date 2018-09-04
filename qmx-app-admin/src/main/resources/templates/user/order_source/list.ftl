<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>订单来源</title>
<#include "/include/header_include_old.ftl">
<script type="text/javascript">
$().ready(function() {
	
	$(".disabled").click(function() {
		var $this = $(this);
		$.dialog({
			type: "warn",
			content: "确定要禁用吗？",
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
			content: "确定要启用吗？",
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
			订单来源列表 
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
		<div class="bar">
			<input type="text" id="searchValue" name="name" value="${queryDto.name!}" maxlength="200" />
			<button type="submit" class="button">查询</button>
		</div>
		<div class="bar">
		<@shiro.hasPermission name = "admin:addOrderSource">
            <a href="add" class="button">
                添加订单来源
            </a>
		</@shiro.hasPermission>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					订单来源名称
				</th>
				<@shiro.hasRole name = 'admin'>
                <th>
                    ota专用
                </th>
				<th>
					是否系统内置
				</th>
				</@shiro.hasRole>
				<th>
					状态
				</th>
				<th>
					所属人
				</th>
				<th>
					<span>操作</span>
				</th>
			</tr>
			<#list page.records as ad>
				<tr>
					<td>
						<input type="checkbox" name="ids" value="${ad.id}" />
					</td>
					<td>
						<span title="${ad.name}">${ad.remark!}-${ad.name!}-${ad.code!}</span>
					</td>
					<@shiro.hasRole name = 'admin'>
					<td>
					${ad.otaFlag?string('是','否')}
					</td>
					<td>
						${ad.sys?string('是','否')}
					</td>
					</@shiro.hasRole>
					<td>
						<#if !ad.enable>
							<span class="red">禁用</span>
							<#else>
							<span class="green">启用</span>
						</#if>
					</td>
					<td>
						<#if ad.member??>
						${ad.member.username}(${ad.member.account})
						</#if>
					</td>
					<td>
						<@shiro.hasPermission name = "admin:updateOrderSource">
							<@shiro.hasRole name = 'admin'>
                            <a href="edit.jhtml?id=${ad.id}">[编辑]</a>
							</@shiro.hasRole>
							<@shiro.lacksRole name = 'admin'>
								<#if !ad.sys>
                                <a href="edit.jhtml?id=${ad.id}">[编辑]</a>
								</#if>
							</@shiro.lacksRole>
						</@shiro.hasPermission>
						<#--<a href="javascript:;" class="disabled">[禁用]</a>
						<a href="javascript:;" class="enabled">[启用]</a>-->
					</td>
				</tr>
			</#list>
		</table>
			<#include "/include/pagination.ftl">
	</form>
</body>
</html>
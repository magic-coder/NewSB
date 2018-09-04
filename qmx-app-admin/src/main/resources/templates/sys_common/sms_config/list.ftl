<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>支付退款列表</title>
<#include "/include/header_include_old.ftl">
    <script src="${base}/resources/assets/layer/layer.js"></script>
	<script type="text/javascript">

	</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
            短信通道列表
	    </div>
	</div>
	<form id="listForm" action="list" method="get">
        <div class="bar">
		<@shiro.hasPermission name = "admin:addSmsConfig">
            <a href="add" class="button">添加通道</a>
		</@shiro.hasPermission>
        </div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
                    配置名称
				</th>
				<th>
                    短信平台
				</th>
				<th>
                    短信平台帐号
				</th>
                <th>
                    短信平台密码
                </th>
				<th>
                    供应商名称
				</th>
                <th>
                    是否系统内置
                </th>
                <th>
                    所属人
                </th>
                <th>
                    添加时间
                </th>
                <th>
                    修改时间
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
					${dto.configName!}
                    </td>
					<td>
						${dto.smsPlatType.getName()!}
					</td>
					<td>
						${dto.smsPlatAccount!}
					</td>
                    <td>
					******
                    </td>
					<td>
						${dto.supplierName!}
					</td>
                    <td>
                    ${dto.sys?string("是","否")}
                    </td>
                    <td>
					${dto.memberName!}
                    </td>
                    <td>
					${dto.createTime?datetime}
                    </td>
                    <td>
						${dto.updateTime?datetime}
                    </td>
                    <td>
						<@shiro.hasPermission name = "admin:updateSmsConfig">
                            <a href="edit?id=${dto.id!}">编辑</a>
						</@shiro.hasPermission>
                    </td>
				</tr>
			</#list>
		</table>
	<#include "/include/pagination.ftl">
	</form>
</body>
</html>
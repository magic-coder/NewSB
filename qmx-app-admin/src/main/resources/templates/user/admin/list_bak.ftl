<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>管理员列表</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
            管理员列表
	    </div>
	</div>
	<form id="listForm" action="list.jhtml" method="get">
		<div class="bar">
			<br/>
			<input type="text" placeholder="登录账号" value="${(userQueryVo.account)!}" name="account" maxlength="200" />
            <input type="text" placeholder="用户名" value="${(userQueryVo.username)!}" name="username" maxlength="200" />

            <select name="userType">
                <option value="">--用户类型--</option>
                <option <#if userQueryVo?? && userQueryVo.userType?? && userQueryVo.userType='admin'>selected</#if> value="admin">管理员</option>
                <option <#if userQueryVo?? && userQueryVo.userType?? && userQueryVo.userType='distributor'>selected</#if> value="distributor">分销商</option>
                <option <#if userQueryVo?? && userQueryVo.userType?? && userQueryVo.userType='supplier'>selected</#if> value="supplier">供应商</option>
                <option <#if userQueryVo?? && userQueryVo.userType?? && userQueryVo.userType='employee'>selected</#if> value="employee">员工</option>
            </select>
            <input type="text" placeholder="地区" value="${(userQueryVo.areaId)!}" name="areaId" maxlength="200" />
            <input type="text" placeholder="地址" value="${(userQueryVo.address)!}" name="address" maxlength="200" />
            <input type="text" placeholder="部门" value="${(userQueryVo.deptId)!}" name="deptId" maxlength="200" />
            <input type="text" placeholder="邮件" value="${(userQueryVo.email)!}" name="email" maxlength="200" />
            <input type="text" placeholder="所属人" value="${(userQueryVo.memberId)!}" name="memberId" maxlength="200" />
            <input type="text" placeholder="电话" value="${(userQueryVo.phone)!}" name="phone" maxlength="200" />
            <input type="text" placeholder="供应商" value="${(userQueryVo.supplierId)!}" name="supplierId" maxlength="200" />
			<select name="locked">
                <option value="">--是否锁定--</option>
                <option <#if userQueryVo?? && userQueryVo.locked?? && userQueryVo.locked>selected</#if> value="true">锁定</option>
                <option <#if userQueryVo?? && userQueryVo.locked?? && !userQueryVo.locked>selected</#if> value="false">正常</option>
            </select>
            <select name="enable">
                <option value="">--是否启用--</option>
                <option <#if userQueryVo?? && userQueryVo.enable?? && userQueryVo.enable>selected</#if> value="true">启用</option>
                <option <#if userQueryVo?? && userQueryVo.enable?? && !userQueryVo.enable>selected</#if> value="false">禁用</option>
            </select>
			<button type="submit" class="button">查询</button>
			<button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
			<span style="color:green;">${flash_message_attribute_name!}</span>
		</div>
		<div class="bar">
			&nbsp;

                <a href="add" class="button">
                    添加
                </a>
		</div>
		<table id="listTable" class="list">
			<tr>
				<th class="check">
					<input type="checkbox" id="selectAll" />
				</th>
				<th>
					账号
				</th>
				<th>
					名称
				</th>
				<th>
					手机
				</th>
				<th>
					地区
				</th>
                <th>
                    最后登录
                </th>
				<th>
					是否启用
				</th>
                <th>添加日期</th>
				<th>添加人</th>
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
					${dto.account!'-'}
                    </td>
					<td>
						${dto.username!'-'}
					</td>
					<td>
						${dto.phone!'-'}
					</td>
					<td>
						${dto.areaId!'-'}
					</td>
                    <td>
						${(dto.lastLoginTime?string("yyyy-MM-dd HH:mm:ss"))!'-'}
                    </td>
					<td>
                        <span class="${dto.enable?string("true", "false")}Icon">&nbsp;</span>
					</td>
					<td>${dto.createTime?string("yyyy-MM-dd HH:mm:ss")}</td>
                    <td>${dto.createBy!'-'}</td>
					<td>
                        <a href="edit?id=${dto.id}">[编辑]</a>
						<a href="deletex?id=${dto.id}">[删除]</a>
                        <a href="../authority/edit?id=${dto.id}">[权限设置]</a>
					</td>
				</tr>
			</#list>
		</table>
			<#include "/include/pagination.ftl">
	</form>
</body>
</html>
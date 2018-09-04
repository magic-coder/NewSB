<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
</head>
<body>
<form id="listForm" class="layui-form" action="list" style="margin-top: 20px;">
    <div class="layui-form-item">
        <div class="layui-inline" style="padding-left: 10px;">
            <div class="layui-input-inline">
                <input class="layui-input" value="${(userQueryVo.account)!}" name="account" maxlength="200" placeholder="登录账号"/>
            </div>
            <div class="layui-input-inline">
                <input class="layui-input" value="${(userQueryVo.username)!}" name="username" maxlength="200" placeholder="账号名称"/>
            </div>
            <div class="layui-input-inline">
                <select name="locked">
                    <option value="">--是否锁定--</option>
                    <option <#if userQueryVo?? && userQueryVo.locked?? && userQueryVo.locked>selected</#if> value="true">锁定</option>
                    <option <#if userQueryVo?? && userQueryVo.locked?? && !userQueryVo.locked>selected</#if> value="false">正常</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="enable">
                    <option value="">--是否启用--</option>
                    <option <#if userQueryVo?? && userQueryVo.enable?? && userQueryVo.enable>selected</#if> value="true">启用</option>
                    <option <#if userQueryVo?? && userQueryVo.enable?? && !userQueryVo.enable>selected</#if> value="false">禁用</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <input class="layui-input" placeholder="供应商" value="${(userQueryVo.supplierAccount)!}" name="supplierAccount" maxlength="200" placeholder="供应商"/>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<@shiro.hasPermission name = "admin:addDistributor">
<div class="layui-form-item" style="margin-left: 10px;">
    <a href="add" class="layui-btn">添加分销商</a>
</div>
</@shiro.hasPermission>
<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            账号和名称
        </th>
        <th>
            账号类型
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
        <th>所属供应商</th>
        <th>
            <span>操作</span>
        </th>
    </tr>
    </thead>
    <tbody>
	<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
		${dto.account!'-'}/${dto.username!'-'}
        </td>
        <td>
            <#if dto.userType == 'distributor'>
                ${dto.level!}级分销商
            <#else>
            ${dto.userType.getName()}
            </#if>
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
            ${dto.enable?string("是", "否")}
        </td>
        <td>${dto.createTime?string("yyyy-MM-dd HH:mm:ss")}</td>
        <td>${dto.supplierAccount!'-'}</td>
        <td>
            <@shiro.hasPermission name = "admin:updateDistributor">
                <a id="editAdmin" href="edit?id=${dto.id}"/>[编辑]</a>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "admin:deleteDistributor">
                <a class="del" url="delete?id=${dto.id}">[删除]</a>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "admin:editDistributorPermission">
                <a href="../authority/edit?id=${dto.id}">[权限设置]</a>
            </@shiro.hasPermission>
        </td>
    </tr>
	</#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
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
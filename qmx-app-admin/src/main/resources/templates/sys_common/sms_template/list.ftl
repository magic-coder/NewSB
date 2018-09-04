<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        $().ready(function () {

        });
    </script>
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>短信模板列表</legend>
</fieldset>
<form id="listForm" class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">模板名称</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="name" value="${queryDto.name!}" placeholder="模板名称"/>
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

<div class="layui-form-item" style="margin-left: 10px;">
<@shiro.hasPermission name = "admin:addSmsTemplate">
    <a href="add" class="layui-btn">添加模板</a>
</@shiro.hasPermission>
<@shiro.hasPermission name = "admin:deleteSmsTemplate">
    <a href="delete" class="layui-btn">删除模板</a>
</@shiro.hasPermission>
</div>
<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="title">模板名称</a>
        </th>
        <th>
            配置名称
        </th>
        <th>
            <a href="javascript:;" class="sort" name="type">模板类型</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="templateCode">模板CODE</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="signName">模板签名</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="content">模板内容</a>
        </th>
        <th style="width: 50px;">
            <span>操作</span>
        </th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as warehouse>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${warehouse.id}"/>
        </td>
        <td>
        ${warehouse.name!}
        </td>
        <td>
        ${warehouse.configName!}
        </td>
        <td>
        ${warehouse.templateType.getName()!}
        </td>
        <td>
        ${warehouse.templateCode}
        </td>
        <td>
        ${warehouse.signName}
        </td>
        <td>
            <span title="${warehouse.content!}">${warehouse.content!}</span>
        </td>
        <td>
            <@shiro.hasPermission name = "admin:updateSmsTemplate">
                <a href="edit.jhtml?id=${warehouse.id}">[编辑]</a>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
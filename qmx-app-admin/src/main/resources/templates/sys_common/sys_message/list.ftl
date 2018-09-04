<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
    <#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form','table','laydate'], function(){
            var table = layui.table, form = layui.form;
            $(document).on("click","#addSysMessage",function () {
                var index = layer.open({
                    type: 2,
                    title: '发送消息',
                    area: ['500px', '500px'], //宽高
                    fix: true, //固定
                    content: '/sysMessage/add'
                });
            })
        });
    </script>
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>列表</legend>
</fieldset>
<form id="listForm" class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-input-inline" style="margin-left: 10px;">
            <input class="layui-input" name="title" value="${queryDto.title!}" placeholder="标题"/>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<@shiro.hasPermission name = "admin:sendSysMessage">
<div class="layui-form-item" style="margin-left: 10px;">
    <a href="javascript:;" id="addSysMessage" class="layui-btn">发送消息</a>
</div>
</@shiro.hasPermission>

<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            标题
        </th>
        <th>
            内容
        </th>
        <th>
            发送人
        </th>
        <th>
            接收用户类型
        </th>
        <th>
            添加/修改时间
        </th>
        <th style="width: 50px;">
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
        ${dto.title!}
        </td>
        <td>
        ${dto.content!}
        </td>
        <td>
        ${dto.sendUserName!}
        </td>
        <td>
            <#if dto.reciveUserType??>
            ${dto.reciveUserType.getName()!}
            <#else>
            -
            </#if>
        </td>
        <td>
            ${dto.createTime?datetime}/${dto.updateTime?datetime}
        </td>
        <td>
            <a href="delete?id=${dto.id}">[删除]</a>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
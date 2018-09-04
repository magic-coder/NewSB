<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>景区列表</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use(['form','table'], function(){
            var table = layui.table,form = layui.form;
            $(document).on("click","#viewAppKey",function(){
                var data = $(this).attr("data-id");
                var index = layer.open({
                    type: 2,
                    title: '查看Appkey',
                    area: ['600px', '300px'], //宽高
                    fix: true, //固定
                    content: '/userApi/apiInfo?sightId='+data
                });
            });
        });
    </script>
</head>

<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>景区列表</legend>
</fieldset>
<form id="listForm" class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">景区名称</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="sightName" value="${sysSightVO.sightName!}" placeholder="景区名称"/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">地区</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="areaName" placeholder="地区" value="${sysSightVO.areaName!}"/>
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
<@shiro.hasPermission name = "admin:addSight">
    <a href="add.jhtml" class="layui-btn">添加</a>
</@shiro.hasPermission>
<@shiro.hasPermission name = "admin:deleteSight">
    <a href="javascript:;" id="deleteButton" class="layui-btn">
        删除
    </a>
</@shiro.hasPermission>
</div>

<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="name">景区名称</a>
        </th>
        <#--<th>
            <a href="javascript:;" class="sort" name="principal">景区负责人</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="biz">商务负责人</a>
        </th>-->
        <th>
            <a href="javascript:;" class="sort" name="orderPhone">预定电话</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="area">地区</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="state">添加时间</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="state">修改时间</a>
        </th>
        <th>
            <span>操作</span>
        </th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as company>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${company.id}"/>
        </td>
        <td>
        ${company.sightName}
        </td>
        <#--<td>
        ${company.principal!}
        </td>
        <td>
        ${company.biz!}
        </td>-->
        <td>
        ${company.orderPhone}
        </td>
        <td>
            <#if company.area??>
            ${company.area.fullName!}
            <#else>
                -
            </#if>
        </td>
        <td>
        ${company.createTime?datetime!}
        </td>
        <td>
        ${company.updateTime?datetime!}
        </td>
        <td>
            <@shiro.hasPermission name = "admin:editSight">
                <a href="edit.jhtml?id=${company.id}" class="layui-btn">编辑</a>
            </@shiro.hasPermission>
            <a href="javascript:;" id="viewAppKey" data-id="${company.id!}">[查看AppKey]</a>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
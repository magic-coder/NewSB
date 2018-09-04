<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>商品列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.render();
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>商品入库列表</legend>
</fieldset>
<form class="layui-form" action="list" method="get">
<#--<div class="layui-form-item">
        <div class="layui-inline">

        </div>
        <div class="layui-inline">

        </div>
    </div>-->
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
        </div>

    </div>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th>
            采购数量
        </th>
        <th>
            出入库状态
        </th>
        <th>
            创建时间
        </th>
        <th>
            创建人
        </th>
    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
        ${dto.stock!}
        </td>
        <td>
        <#if dto.status?string("true","false")=="true">
            入库
        <#else>
            出库
        </#if>
        </td>
        <td>
        ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td>
        ${dto.createName!}
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
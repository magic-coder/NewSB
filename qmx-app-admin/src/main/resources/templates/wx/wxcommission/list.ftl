<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'element'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;
            var element = layui.element;
        });
    </script>
</head>
<body>
<#include "tab.ftl"/>

<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">昵称</label>
            <div class="layui-input-inline">
                <input type="text" name="nickname" value="" autocomplete="off"
                       class="layui-input" placeholder="昵称">
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
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;">
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            订单号
        </th>
        <th>
            返佣人
        </th>
        <th>
            返佣金额
        </th>
        <th>
            是否结算
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td>
            <input name="id" type="checkbox" value="${(dto.id)!}"/>
        </td>
        <td>
        ${dto.wxOrder!?c}
        </td>
        <td>
        ${dto.benefit!?c}
        </td>
        <td>
        ${(dto.amount)!}
        </td>
        <td>
            <#if dto.settlement>
                是
            <#else>
                否
            </#if>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
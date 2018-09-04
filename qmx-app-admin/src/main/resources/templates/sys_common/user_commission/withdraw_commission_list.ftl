<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>佣金列表</title>
    <#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        $(function () {
            $("#userCommissionWithDraw").click(function () {
                var data = $(this).attr("data-id");
                layer.open({
                    type: 2,
                    title: '佣金提现',
                    area: ['680px', '400px'], //宽高
                    fix: true, //固定
                    content: 'preRefund?id='+data
                });
            });
        });
    </script>
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>佣金列表</legend>
</fieldset>
<form id="listForm" class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="userName" value="${queryDto.userName!}" placeholder="用户名"/>
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
    <a href="javascript:;" id="userCommissionWithDraw" class="layui-btn">佣金提现</a>
</div>

<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            用户名
        </th>
        <th>
            佣金内容
        </th>
        <th>
            金额
        </th>
        <th>
            退款数量
        </th>
        <th>
            佣金来源
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
        ${dto.userName!}
        </td>
        <td>
        ${dto.body!}
        </td>
        <td>
        ${dto.amount?string("0.00")}
        </td>
        <td>
        ${dto.refundQuantity!}
        </td>
        <td>
            ${dto.commissionSource.getName()!}
        </td>
        <td>
            <a href="edit.jhtml?id=${dto.id}">[编辑]</a>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
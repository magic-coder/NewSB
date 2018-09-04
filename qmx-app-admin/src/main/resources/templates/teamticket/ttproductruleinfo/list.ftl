<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

        });

        $(document).on("click", "#view", function () {
            var data = $(this).attr("data-id");
            var index = layer.open({
                type: 2,
                title: '绩效明细',
                area: ['80%', '80%'], //宽高
                fix: true, //固定
                content: 'view?memberId=' + data
            });
        });

        $(document).on("click", "#settle", function () {
            var data = $(this).attr("data-id");
            var index = layer.open({
                type: 2,
                title: '结算绩效',
                area: ['80%', '80%'], //宽高
                fix: true, //固定
                content: 'settleList?memberId=' + data
            });
        });
    </script>
    <script>
        //删除
        $(document).on("click", "#deleteBtn", function () {
            var data = $(this).attr("data-id");
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "delete",
                    type: "POST",
                    data: {id: data},
                    beforeSend: function () {
                    },
                    success: function (json) {
                        if (json.state == "success") {
                            layer.msg(json.msg);
                            setTimeout(function () {
                                location.reload(true);
                            }, 500);
                        } else {
                            layer.msg(json.msg);
                        }
                    }
                });
            }, function () {

            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>绩效规则</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="account" value="${dto.account!}" autocomplete="off"
                       class="layui-input" placeholder="员工">
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
<@shiro.hasPermission name="admin:ttPrinfoExportTotal">
    <button onclick="location.href='exportTotal';" class="layui-btn layui-btn-normal">导出</button>
</@shiro.hasPermission>
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>员工</th>
        <th>历史绩效总额</th>
        <th>已发放绩效总额</th>
        <th>待发放总额</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>${dto.account!}</td>
        <td>${dto.totalAmount!?string("0.##")}</td>
        <td>
        ${dto.issuedAmount!?string("0.##")}
        </td>
        <td>
        ${(dto.unissuedAmount!)?string("0.##")}
        </td>
        <td>
            <@shiro.hasPermission name="admin:ttPrinfoSettle">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.memberId!}"
                       id="settle"
                       value="结算绩效"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:ttPinfoSettleList">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.memberId!}"
                       onclick="window.location.href='billList?memberId=${dto.memberId!}'" value="已结账单"/>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>产品列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
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
    <script>
        /*$(document).ready(function (e) {
            $("#selectAll").click(function () {
                if (this.checked) {
                    $("[name=ids]").attr("checked", true);
                } else {
                    $("[name=ids]").attr("checked", false);
                }
            });
            $("tr").slice(1).click(function (e) {
                // 找到checkbox对象
                var ids = $("input[name=ids]", this);
                if (ids.length < 1) {
                    return;
                }
                if (ids[0].checked) {
                    $("[name=ids]", this).attr("checked", false);
                } else {
                    $("[name=ids]", this).attr("checked", true);
                }
            });
        });*/
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>车辆列表</legend>
</fieldset>
<div class="layui-form-item" style="margin-left: 10px;">
<@shiro.hasPermission name="admin:taCarCreate">
    <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
</@shiro.hasPermission>
</div>

<table class="layui-table"
       id="listTable" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;"
       lay-size="sm">
    <thead>
    <tr>
        <th rowspan="2">时间条件</th>
        <th rowspan="2">旅行社名称</th>
        <th rowspan="2">门票名称</th>
        <th rowspan="2">消费数量</th>
        <th colspan="3" style="text-align: center">定金</th>
        <th colspan="5" style="text-align: center">尾款</th>
        <th rowspan="2">合计付款</th>
        <th rowspan="2">挂账待结金额</th>

    </tr>
    <tr>
        <th>预存款</th>
        <th>支付宝支付</th>
        <th>微信支付</th>
        <th>现金</th>
        <th>预存款</th>
        <th>银行转账</th>
        <th>支付宝转账</th>
        <th>微信转账</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td rowspan="2">${dto.date!}</td>
        <td>${dto.memberName!}</td>

    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
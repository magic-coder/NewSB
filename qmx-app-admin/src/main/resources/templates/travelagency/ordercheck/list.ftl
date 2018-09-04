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
        //落单
        $(document).on("click", "#single", function () {
            var data = $(this).attr("data-id");
            layer.confirm('确定落单吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    type: 'Get',
                    url: 'single',
                    data: {id: data},
                    success: function (result) {
                        if (result.flag == '落单成功') {
                            layer.msg(result.flag);
                            setTimeout(function () {
                                location.reload(true);
                            }, 500);
                        } else {
                            layer.msg(result.flag);
                        }
                    }
                });
            }, function () {

            });
        });

        //审核
        $(document).on("click", "#check", function () {
            var data = $(this).attr("data-id");
            layer.confirm('确定审核吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    type: 'Get',
                    url: 'check',
                    data: {id: data},
                    success: function (result) {
                        if (result.flag == '审核成功') {
                            layer.msg(result.flag);
                            setTimeout(function () {
                                location.reload(true);
                            }, 500);
                        } else {
                            layer.msg(result.flag);
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
    <legend>订单列表</legend>
</fieldset>
<form class="layui-form" method="post" action="list">
    <div class="layui-form-item">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="sn" value="${dto.sn!}" autocomplete="off"
                       class="layui-input" placeholder="订单编号">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery"
                        id="inquire">查询
                </button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item" style="margin-left: 10px;">
<#--<button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>-->
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>订单编号</th>
        <th>所属旅行社</th>
        <th>接单状态</th>
        <th>审核状态</th>
        <th>支付状态</th>
        <th>总金额</th>
        <th>定金</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>${dto.sn!}</td>
        <td>${dto.memberName!}</td>
        <td>${dto.orderStatus.title!}</td>
        <td>${dto.checkStatus.title!}</td>
        <td>${dto.taPaymentStatus.title!}</td>
        <td>${dto.totalAmount!}</td>
        <td>${dto.deposit!}</td>
        <td>
        <#--<input type="button" onclick="location.href='edit?id=${dto.id!}';"
               class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="editBtn"
               value="查看"/>-->
            <@shiro.hasPermission name="admin:taOrderSingle">
                <#if dto.taPaymentStatus=='buyer'||dto.taPaymentStatus=='finalpaid'||dto.taPaymentStatus=='paid'>
                    <input type="button" onclick="location.href='/taOrderPrint/print?id=${dto.id!}';"
                           class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" value="单据下载"/>
                </#if>
            </@shiro.hasPermission>
            <@shiro.hasPermission name="admin:taOrderAmend">
                <#if dto.taPaymentStatus!='finalpaid'&&dto.taPaymentStatus!='paid'>
                    <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                           class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="editBtn"
                           value="修改"/>
                </#if>
            </@shiro.hasPermission>
            <#if dto.checkStatus??&&dto.checkStatus=='applied'>
                <@shiro.hasPermission name="admin:taOrderCheck">
                    <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="check"
                           value="审核"/>
                </@shiro.hasPermission>
            </#if>

        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
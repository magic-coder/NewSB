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
        //订单支付
        $(document).on("click", "#paymentBtn", function () {
            var data = $(this).attr("data-id");
            var type = $(this).attr("data-type");
            var index = layer.open({
                type: 2,
                title: '订单支付',
                area: ['70%', '70%'], //宽高
                fix: true, //固定
                content: 'payment?id=' + data + "&type=" + type,
                end: function () {
                    location.reload();
                }
            });
        });
        //接单
        $(document).on("click", "#orderReceiving", function () {
            var data = $(this).attr("data-id");
            layer.confirm('确定接单吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "orderReceiving",
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
        })

        //发送短信
        $(document).on("click", "#sendMessages", function () {
            var data = $(this).attr("data-id");
            layer.confirm('确定发送吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "sendMessages",
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
        })
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
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">订单编号</label>
            <div class="layui-input-inline">
                <input type="text" name="sn" value="${dto.sn!}" autocomplete="off"
                       class="layui-input">
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
</div>

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>客户经理短信模版</th>
        <th>旅行社联系人短信模版</th>
        <th>导游/领队短信模版</th>
        <th>司机短信模版</th>
        <th>创建人</th>
        <th>创建时间</th>
    <#--<th>操作</th>-->
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>${dto.managerNoteName!}</td>
        <td>${dto.contactsNoteName!}</td>
        <td>${dto.guideNoteName!}</td>
        <td>${dto.driverNoteName!}</td>
        <td>
        ${dto.createName!}
        </td>
        <td>
        ${dto.createTime!?string("yyyy-MM-dd HH:mm:ss")}
        </td>
    <#--<td>
        <@shiro.hasPermission name="admin:taOrderEdit">
            <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="editBtn"
                   value="编辑"/>
        </@shiro.hasPermission>
        <#if '${dto.taPaymentStatus}'=='unpaid'>
            <@shiro.hasPermission name="admin:taOrderPaydt">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       id="paymentBtn" value="支付定金" data-type="deposit"/>
            </@shiro.hasPermission>
        <#elseif '${dto.taPaymentStatus}'=='depositpaid'>
            <@shiro.hasPermission name="admin:taOrderPayfinal">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       id="paymentBtn" value="支付尾款" data-type="finalPay"/>
            </@shiro.hasPermission>
        </#if>
        <#if '${dto.orderStatus!}'=='unhaveOrder'&&'${dto.taPaymentStatus!}'!='unpaid'>
            <@shiro.hasPermission name="admin:taOrderReceiving">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       id="orderReceiving" value="接单"/>
            </@shiro.hasPermission>
        </#if>
        <@shiro.hasPermission name="admin:taOrderDelete">
            <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="deleteBtn"
                   value="删除"/>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="admin:taOrderView">
            <input type="button" onclick="location.href='view?id=${dto.id!}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="editBtn"
                   value="查看"/>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="admin:taOrderSendsms">
            <#if '${dto.noteSendStatus!}'=='unsent'>
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}"
                       id="sendMessages"
                       value="通知接单"/>
            </#if>
        </@shiro.hasPermission>
    </td>-->
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
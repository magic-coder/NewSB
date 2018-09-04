<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>退款列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            //同意退款
            $(document).on("click", "#agreeBtn", function () {
                var data = $(this).attr("data-id");
                layer.confirm('确定同意退款吗？', {
                    btn: ['确定', '取消'] //按钮
                }, function () {
                    $.ajax({
                        url: "agreeRefund",
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

            //拒绝退款
            $(document).on("click", "#refuseBtn", function () {
                var data = $(this).attr("data-id");
                layer.confirm('确定拒绝退款吗？', {
                    btn: ['确定', '取消'] //按钮
                }, function () {
                    $.ajax({
                        url: "refuseRefund",
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

        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>退款列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">订单号</label>
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

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th><input type="checkbox" id="selectAll"/></th>
        <th>订单号</th>
        <th>退款状态</th>
        <th>退款金额</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
        ${dto.sn!}
        </td>
        <td>
        ${dto.status.title}
        </td>
        <td>
        ${dto.amount?string.currency}
        </td>
        <td>
            <@shiro.hasPermission name="admin:ttRefundAudit">
                <#if dto.status == "applied">
                    <input type="button" class="layui-btn layui-btn-normal layui-btn-sm"
                           data-id="${dto.id!}" id="agreeBtn" value="同意退款"/>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal"
                           data-id="${dto.id!}" id="refuseBtn" value="拒绝退款"/>
                </#if>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
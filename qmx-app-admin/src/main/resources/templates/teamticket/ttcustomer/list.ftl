<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>客户列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <script>
        //清账
        $(document).on("click", "#closeoutBtn", function () {
            var data = $(this).attr("data-id");
            var index = layer.open({
                type: 2,
                title: '订单清账',
                area: ['80%', '80%'], //宽高
                fix: true, //固定
                content: 'closeout?customerId=' + data
            });
        });
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
        $(document).ready(function (e) {
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
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>客户列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">单位名称</label>
            <div class="layui-input-inline">
                <input type="text" name="enterpriseName" value="${dto.enterpriseName!}" autocomplete="off"
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
<div class="layui-form-item">
    &nbsp;
<@shiro.hasPermission name = "ttcustomer:add">
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
        </div>
    </div>
</@shiro.hasPermission>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            公司名称
        </th>
        <th>
            客户类型
        </th>
        <th>
            结算类型
        </th>
        <th>
            未清算金额
        </th>
        <th>
            操作
        </th>
    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
        ${dto.enterpriseName!}
        </td>
        <td>
        ${dto.type.title!}
        </td>
        <td>
            <#if dto.guazhang>挂账<#else>普通</#if>
        </td>
        <td>
            <#if dto.guazhang>${dto.GZmount!}￥</#if>
        </td>
        <td>
            <@shiro.hasPermission name = "ttcustomer:edit">
                <input type="button" onclick="location.href='edit?id=${dto.id!?c}';" class="layui-btn layui-btn-sm"
                       value="编辑"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "ttcustomer:accounting">
                <input type="button" class="layui-btn layui-btn-sm" data-id="${dto.id!?c}" value="清账" id="closeoutBtn"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "ttcustomer:delete">
                <input type="button" class="layui-btn layui-btn-sm" data-id="${dto.id!}" value="删除" id="deleteBtn"/>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
</body>
</html>
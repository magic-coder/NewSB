<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>客户列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
        //提交iframe
        $(document).on("click", "#submitIframe", function () {
            var $customerId = $('input:radio:checked');
            if ($customerId.val() == "") {
                layer.msg("请选择客户");
                return;
            }
            /*$.ajax({
                url: "getByCustomerId",
                type: "POST",
                data: {customerId: $customerId.val()},
                beforeSend: function () {
                },
                success: function (data) {
                    parent.$('#productTable tr:not(:first)').remove();
                    for (var i = 0; data.length; i++) {
                        var $tr = '<tr>' +
                                '<td>' +
                                '<input type="hidden" name="productId" class="productId" value="' + data[i].id + '">' + data[i].name + '</td>' +
                                '<td><input name="price_' + data[i].id + '" class="layui-input"></td>' +
                                '<td><input name="quantity_' + data[i].id + '" class="layui-input"></td>' +
                                '<td><a href="javascript:;" class="deleteItem">删除</a></td>' +
                                '</tr>';
                        parent.$('#productTable').append($tr);
                    }
                }
            });*/
            parent.$("#customerId").val($customerId.val());
            console.log($customerId.next());
            if ($customerId.next().val() == 'true') {
                parent.$("#customerSpan").html($customerId.parents("tr:eq(0)").find("td:eq(1)").text() + "|结算类型:挂账客户");
            } else {
                parent.$("#customerSpan").html($customerId.parents("tr:eq(0)").find("td:eq(1)").text() + "|结算类型:普通客户");
            }
            parent.layer.close(index);
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
                $("[name=ids]", this).attr("checked", true);
            });
        });
    </script>
</head>
<body>
<hr/>
<form class="layui-form" action="getProducts" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">客户名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='getProducts';" class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check">
            #
        </th>
        <th>
            名称
        </th>
    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="radio" name="ids" value="${dto.id}"/>
            <input type="hidden" name="guazhang" value="${dto.guazhang?string("true","false")}"/>
        </td>
        <td>
        ${dto.enterpriseName!}
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">

<div class="layui-form-item">
    <div align="center">
        <div>
            <input id="submitIframe" type="button" class="layui-btn layui-btn-normal" value="确定"/>
            <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
        </div>
    </div>
</div>
</body>
</html>
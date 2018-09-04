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
            var $checkedIds = $("input[name='ids']:enabled:checked");
            $checkedIds.each(function () {
                var id = $(this).val();
                var tr = $(this).parents("tr:eq(0)");
                var marketPrice = $(this).next().val();
                addProductItem({
                    id: id,
                    name: tr.find("td:eq(1)").text(),
                    marketPrice:marketPrice
                });
                parent.layer.close(index);
            });
        });

        function addProductItem(data) {
            var repeat = false;
            parent.$("#productTable input.productId").each(function () {
                var tmp = $(this).val();
                if (tmp == data.id) {
                    repeat = true;
                    return false;
                }
            });
            if (repeat) {
                return false;
            }
            var $tr = '<tr>' +
                    '<td>' +
                    '<input type="hidden" name="aid" class="aid" value="">' +
                    '<input type="hidden" name="marketPrice" value="' + data.marketPrice + '">' +
                    '<input type="hidden" name="productId" class="productId" value="' + data.id + '">' + data.name + '</td>' +
                    '<td><input name="price" class="layui-input"  lay-verify="required|price"></td>' +
                    '<td><input name="size" class="layui-input" lay-verify="required|size"></td>' +
                    '<td><a href="javascript:;" class="deleteItem">删除</a></td>' +
                    '</tr>';
            parent.$('#productTable').append($tr);
        }
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
<hr/>
<form class="layui-form" action="getProducts" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">产品名称</label>
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
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            名称
        </th>
    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
            <input type="hidden" id="marketPrice" name="marketPrice" value="${dto.marketPrice!}"/>
        </td>
        <td>
        ${dto.name!}
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
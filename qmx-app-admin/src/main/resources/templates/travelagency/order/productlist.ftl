<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
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
                addProductItem({
                    id: id,
                    name: tr.find("td:eq(1)").text()
                });
            });
            parent.layer.close(index);
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
            var title = "";
            //获取协议id
            var agreementId = $("#agreementId").val();
            $.ajax({
                url: "getProductPolicyList",
                type: "POST",
                async: false,
                data: {productId: data.id, agreementId: agreementId},
                success: function (json) {
                    for (var i = 0; i < json.length; i++) {
                        title += "数量大于" + json[i].minNumber + "小于" + json[i].maxNumber + "价格为" + json[i].price + "&#10;";
                    }
                    var $tr = '<tr>' +
                            '<td><input type="hidden" name="productId" class="productId" value="' + data.id + '"/><labeld title="' + title + '">' + data.name + '</label><a class="fa fa-eye" style="margin-left: 5px; cursor: pointer;" alt="预览"></a></td>' +
                            '<td><input type="hidden" name="price" value="" class="layui-input"/><labeld class="price"></labeld></td>' +
                            '<td><input name="quantity" value="" lay-verify="required" class="layui-input"/><input name="surplusTotalStock" value="' + json[0].surplusTotalStock + '" type="hidden" class="surplusTotalStock"/></td>' +
                            '<td><input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id="" value="删除"/></td>' +
                            '</tr>';
                    parent.$('#productTable').append($tr);
                }
            });
        }
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
<hr/>
<form class="layui-form" action="getProducts" method="post">
    <input type="hidden" name="agreementId" id="agreementId" value="${dto.agreementId!}"/>
    <input type="hidden" name="stime" value="${dto.stime!}"/>
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
                <button type="reset"
                        onclick="location.href='getProducts?stime=${dto.stime!}&agreementId=${dto.agreementId!}';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
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
            <input type="checkbox" name="ids" value="${dto.id!}"/>
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
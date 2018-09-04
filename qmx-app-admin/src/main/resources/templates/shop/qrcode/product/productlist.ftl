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
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
        //提交iframe
        $(document).on("click", "#submitIframe", function () {
            var $checkedId = $("input[name='ids']:enabled:checked");
            var groupId = $("#groupId").val();

            $.ajax({
                url: "/qrcode/product/addProduct",
                data: {id: $checkedId.val()},
                type: 'get',
                async: true,
                dataType: 'json',
                success: function (data) {
                    parent.$("#outId").val(data.outId);
                    parent.$("#outName").val(data.outName);
                    //统一二维码售价
                    if (data.price != null) {
                        parent.$("#salePrice").attr("readonly", "readonly");
                        parent.$("#salePrice").val(data.price);
                    } else {
                        parent.$("#salePrice").removeAttr("readonly");
                        parent.$("#salePrice").val("");
                    }
                }
            });
            parent.layer.close(index);
        });
    </script>
</head>
<body>
<hr/>
<form class="layui-form" action="getProducts" method="post">
    <input type="hidden" name="groupId" value="${groupId!}" id="groupId"/>
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
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable">
    <thead>
    <tr>
        <th class="check">
            #
        </th>
        <th>
            名称
        </th>
        <th>
            操作人
        </th>
    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="radio" name="ids" value="${dto.id!?c}"/>
        </td>
        <td>
        ${dto.name!}
        </td>
        <td>
        ${dto.createName!}
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>规则-新增</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.verify({
                userId: [/[\S]+/, "请选择员工"]
            });
            form.verify({
                price: [/^[1-9]\d*\.?\d*|0\.?\d*[1-9]\d*$/, "请输入正数"]
            });
            form.verify({
                size: [/^[1-9]\d*$/, "请输入正整数"]
            });
        });
    </script>
    <script>
        //选择员工
        $(document).on("click", "#addUser", function () {
            var index = layer.open({
                type: 2,
                title: '选择员工',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getUsers'
            });
        });
        //选择产品
        $(document).on("click", "#addProduct", function () {
            var userId = $("#userId").val();
            if (userId == "") {
                layer.msg("请先选择员工");
                return;
            }
            var index = layer.open({
                type: 2,
                title: '选择产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getProducts'
            });
        });
        // 删除产品
        $(document).on("click", "#productTable a.deleteItem", function () {
            var $this = $(this);
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function (index) {
                if ($this.attr("data-id")) {
                    $.ajax({
                        url: "deleteAuthorizaProduct",
                        type: "POST",
                        data: {id: $this.attr("data-id")},
                        dataType: "json",
                        beforeSend: function () {
                        },
                        success: function (datas) {
                        }
                    });
                }
                $this.closest("tr").remove();
                layer.close(index);
            }, function () {
            });
        });
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!}"/>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <label class="layui-form-label">选择员工</label>
        <div class="layui-input-block">
            <input type="hidden" id="userId" name="userId" value="${dto.userId!?c}" lay-verify="userId"/>
            <span id="userName">${dto.userName!}</span>
        </div>
    </div>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>产品列表</legend>
    </fieldset>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">产品列表</label>
        <div class="layui-input-inline">
            <input id="addProduct" type="button" class="layui-btn" value="添加产品">
            <hr/>
            <table id="productTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td width="200">
                        最低成单价格
                    </td>
                    <td width="200">
                        最低成单数量
                    </td>
                    <td width="50">
                        操作
                    </td>
                </tr>
            <#list dto.products as product>
                <tr>
                    <td>
                        <input type="hidden" name="aid" class="aid" value="${product.id!}">
                        <input type="hidden" name="productId" class="productId" value="${product.productId!}">
                    ${product.productName!}
                    </td>
                    <td><input name="price" class="layui-input" lay-verify="required|price" value="${product.price!}"></td>
                    <td><input name="size" class="layui-input" lay-verify="required|size" value="${product.size!}"></td>
                    <td><a href="javascript:;" class="deleteItem" data-id="${product.id!?c}">删除</a></td>
                </tr>
            </#list>
            </table>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>
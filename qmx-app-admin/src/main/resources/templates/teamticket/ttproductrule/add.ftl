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
                productId: [/[\S]+/, "请选择产品"]
            });
            form.render('typeName1', 'typeName2');
            form.on('radio(typeName1)', function(data){
                alert(1);
                $("#moneyNumber").attr("lay-verify", "required");
                $("#numberNumber").attr("lay-verify", "");
                $('#numberNumber').attr("disabled",true);
                $('#moneyNumber').removeAttr("disabled");
            });
            form.on('radio(typeName2)', function(data){
                alert(2);
                $("#numberNumber").attr("lay-verify", "required");
                $("#moneyNumber").attr("lay-verify", "");
                $('#moneyNumber').attr("disabled",true);
                $('#numberNumber').removeAttr("disabled");
            });
        });
    </script>
    <script>
        //选择产品
        $(document).on("click", "#addProduct", function () {
            var index = layer.open({
                type: 2,
                title: '选择产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getProducts'
            });
        });
        //选择员工
        $(document).on("click", "#addUser", function () {
            var productId = $("#productId").val();
            if (productId == "") {
                layer.msg("请先选择产品");
                return;
            }
            var index = layer.open({
                type: 2,
                title: '选择员工',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getUser?productId=' + productId
            });
        });
        // 删除员工项
        $(document).on("click", "#userTable a.deleteItem", function () {
            var $this = $(this);
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function (index) {
                if ($this.attr("data-id")) {
                    $.ajax({
                        url: "deleteRuleUser",
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
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <label class="layui-form-label">规则名称</label>
        <div class="layui-input-inline">
            <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">选择产品</label>
        <div class="layui-input-block">
            <input type="hidden" id="productId" name="productId" lay-verify="productId"/>
            <input id="addProduct" type="button" class="layui-btn" value="选择产品">
            <span id="productName"></span>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">绩效方式</label>
        <div class="layui-input-block" lay-filter="typeName">
            <input name="type" value="money" lay-filter="typeName1" title="按销售金额的" type="radio" checked>
            <input id="moneyNumber" name="number" lay-verify="required" autocomplete="off" style="display: inline;width: 50px;" class="layui-input">%提成
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label"></label>
        <div class="layui-input-block">
            <input name="type" value="number" lay-filter="typeName2" title="按销售一张票" type="radio">
            <input id="numberNumber" name="number" lay-verify="" disabled="disabled" autocomplete="off" style="display: inline;width: 50px;" class="layui-input">元
        </div>
    </div>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>关联员工</legend>
    </fieldset>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">员工列表</label>
        <div class="layui-input-inline">
            <input id="addUser" type="button" class="layui-btn" value="添加员工">
            <hr/>
            <table id="userTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        员工账号
                    </td>
                    <td width="200">
                        员工名称
                    </td>
                    <td width="50">
                        操作
                    </td>
                </tr>
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
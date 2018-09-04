<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form'], function () {
            var form = layui.form;

            form.verify({
                deduct: [/^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/, '请输入正确的提成比例!']
            });
        });

        function render() {
            layui.use(['form'], function () {
                var form = layui.form;
                form.render(); //更新全部
            });
        }

        //选择员工
        $(document).on("click", "#memberIdBtn", function () {
            var index = layer.open({
                type: 2,
                title: '选择员工',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getUser'
            });
        });
        //添加产品
        $(document).on("click", "#addProduct", function () {
            var index = layer.open({
                type: 2,
                title: '添加产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getProducts'
            });
        });
        // 删除产品
        $(document).on("click", "#productTable .deleteItem", function () {
            var $this = $(this);
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function (index) {
                if ($this.attr("data-id")) {
                    $.ajax({
                        url: "deleteProduct",
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
        <div class="layui-inline">
            <label class="layui-form-label">选择员工</label>
            <div class="layui-input-inline" style="width: auto;">
                <input id="memberId" name="memberId" type="hidden" lay-verify="required" autocomplete="off"
                       class="layui-input" value="">
                <div id="memberName" class="layui-form-mid"></div>
            </div>
            <div class="layui-input-inline">
                <button id="memberIdBtn" type="button" class="layui-btn">
                    选择
                </button>
            </div>
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">产品列表</label>
        <div class="layui-input-inline">
            <input id="addProduct" type="button" class="layui-btn" value="添加产品">
            <label style="color: red;">添加产品后，需设置价格政策才会保存产品信息</label>
            <hr/>
            <table id="productTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        提成方式
                    </td>
                    <td>
                        提成比例
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>
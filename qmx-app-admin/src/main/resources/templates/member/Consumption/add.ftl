<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>会员等级-新增</title>
<#include "/include/common_header_include.ftl">
    <style type="text/css">

    </style>
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.on('select(aihao)', function (data) {
                var text = data.elem[data.elem.selectedIndex].text;
                $("#levelName").val(text);
            })
        });

        //关联门票
        $(document).on("click", "#MenPiaoBtn", function () {
            var index = layer.open({
                type: 2,
                title: '添加会员等级',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'productlist'
            });
        });
        //关联商品
        $(document).on("click", "#ShopBtn", function () {
            var index = layer.open({
                type: 2,
                title: '添加会员等级',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'releaselist'
            });
        });

    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }

        .layui-unselect layui-form-checkbox layui-form-checked {
            width: 20px;
        }
    </style>
</head>
<body>
<form class="layui-form" id="inputForm" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">等级名称</label>
            <input type="hidden" id="levelName" name="levelName"/>
            <div class="layui-input-inline">
                <select id="levelId" name="levelId" lay-filter="aihao" lay-verify="required">
                    <option value="" selected>--请选择--</option>
                <#list listL as ls>
                    <option value="${ls.id}">${ls.name}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">关联门票</label>
        <div class="layui-input-inline">
            <input id="MenPiaoBtn" type="button" class="layui-btn" value="添加门票">
        <#--<label style="color: red;">添加产品后，需设置价格政策才会保存产品信息</label>-->
            <hr/>
            <table id="productTable" width="100%" class="layui-table">
                <tr>
                    <td width="100">
                        门票名称
                    </td>
                    <td width="100">
                        操作
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">关联商品</label>
        <div class="layui-input-inline">
            <input id="ShopBtn" type="button" class="layui-btn" value="添加商品">
        <#--<label style="color: red;">添加产品后，需设置价格政策才会保存产品信息</label>-->
            <hr/>
            <table id="shopTable" width="100%" class="layui-table">
                <tr>
                    <td width="100">
                        商品名称
                    </td>
                    <td width="100">
                        操作
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <#--<div class="layui-form-item">-->
        <#--<div class="layui-inline">-->
            <#--<label class="layui-form-label">关联产品</label>-->
            <#--<div class="layui-input-inline" style="width: auto;">-->
                <#--<input id="associatedId" name="associatedId" type="hidden" &lt;#&ndash;lay-verify="required"&ndash;&gt;-->
                       <#--autocomplete="off"-->
                       <#--class="layui-input" value="">-->
                <#--<input id="associatedName" type="hidden" name="associatedName" &lt;#&ndash;lay-verify="required"&ndash;&gt;-->
                       <#--autocomplete="off"-->
                       <#--class="layui-input" value=""/>-->
                <#--<input id="userIdName" name="userIdName" value="测试" lay-verify="required" class="layui-input" disabled></input>-->
            <#--</div>-->
            <#--<div class="layui-input-inline">-->
                <#--<button id="userIdBtn" type="button" class="layui-btn">-->
                    <#--添加产品-->
                <#--</button>-->
            <#--</div>-->
        <#--</div>-->
    <#--</div>-->

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">消费积分比率<span style="color: red;font-weight: bold">1:</span></label>
            <div class="layui-input-inline">
                <input name="integralProportion" lay-verify="required|number" autocomplete="off" class="layui-input">
            </div>
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
<script>
    $(document).on("click", "#productTable .deleteItem", function () {
        var $this = $(this);
        layer.confirm('确定删除吗？', {
            btn: ['确定', '取消'] //按钮
        }, function (index) {
//            if ($this.attr("data-id")) {
//                $.ajax({
//                    url: "deleteCustomerProduct",
//                    type: "POST",
//                    data: {id: $this.attr("data-id")},
//                    dataType: "json",
//                    beforeSend: function () {
//                    },
//                    success: function (datas) {
//                    }
//                });
//            }
            $this.closest("tr").remove();
            layer.close(index);
        }, function () {
        });
    });

    $(document).on("click", "#shopTable .deleteItem", function () {
        var $this = $(this);
        layer.confirm('确定删除吗？', {
            btn: ['确定', '取消'] //按钮
        }, function (index) {
//            if ($this.attr("data-id")) {
//                $.ajax({
//                    url: "deleteCustomerProduct",
//                    type: "POST",
//                    data: {id: $this.attr("data-id")},
//                    dataType: "json",
//                    beforeSend: function () {
//                    },
//                    success: function (datas) {
//                    }
//                });
//            }
            $this.closest("tr").remove();
            layer.close(index);
        }, function () {
        });
    });

</script>
</html>
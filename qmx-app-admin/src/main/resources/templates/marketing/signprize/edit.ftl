<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>编辑</title>

<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

        });
        function selectProduct(){
            var index = layer.open({
                type: 2,
                title: '选择产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'couponlist'
            });
        }
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品名称</label>
        <div class="layui-input-inline">
            <input name="name" value="${dto.name!}" lay-verify="required" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">选择门票</label>
        <div class="layui-input-inline" style="width: 300px;">
            <input id="productName" name="productName" value="${dto.productName!}" style="display: inline;width: 190px;" class="layui-input" readonly>
            <input type="hidden" id="productId" name="product" value="${dto.product!?c}" lay-verify="required"/>
            <input type="button" class="layui-btn" onclick="selectProduct();" value="选择门票">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品数量</label>
        <div class="layui-input-inline">
            <input name="amount" value="${dto.amount!}" lay-verify="required|number" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">奖品权重</label>
        <div class="layui-input-inline">
            <input name="weight" value="${dto.weight!}" lay-verify="required|number" autocomplete="off" class="layui-input">
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
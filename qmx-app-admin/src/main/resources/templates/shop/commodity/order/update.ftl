<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>订单-修改</title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/css/bootstrap.min.css"/>
    <#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            form.render('select');
            form.on('select(test)', function(data){
                var checkValue = $("#mailingMethod").val();
                if (checkValue == '1') {
                    $("#mailAddress").show()
                } else {
                    $("#mailAddress").hide();
                }
            });
        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<button id="pay" class="layui-btn layui-btn-normal">支付订单</button>
<form action="updateOrder.jhtml" method="post" id="signupForm" class="layui-form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <input type="hidden" value="${commodityOrderDto.id!}" name="id"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">商品名称:</label>
            <div class="layui-input-inline">
                ${commodityOrderDto.releaseName!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">订购商品数:</label>
            <div class="layui-input-inline">
                <input name="roomNumber" autocomplete="off" lay-verify="required" class="layui-input"
                       value="${commodityOrderDto.quantity!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">总金额:</label>
            <div class="layui-input-inline">
                <input name="payment" id="total" autocomplete="off" lay-verify="required" class="layui-input"
                       value="${commodityOrderDto.payment!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">姓名:</label>
            <div class="layui-input-inline">
                <input name="receiver" autocomplete="off" lay-verify="required" class="layui-input"
                       value="${commodityOrderDto.contactName!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">手机号码:</label>
            <div class="layui-input-inline">
                <input name="receiverPhone" autocomplete="off" lay-verify="required" class="layui-input"
                       value="${commodityOrderDto.contactPhone!}">
            </div>
        </div>
    </div>
   <#-- <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">发货方式:</label>
            <div class="layui-input-inline">
                <select id="mailingMethod"  lay-filter="test">
                    <option value="1" class="layui-input"
                            <#if '${commodityOrderDto.mailingMethod!}' = '1'>selected</#if>>邮寄</option>
                    <option value="2" class="layui-input"
                            <#if '${commodityOrderDto.mailingMethod!}' = '2'>selected</#if>>发码</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item" id="mailAddress">
        <div class="layui-inline">
            <label class="layui-form-label">发货地址:</label>
            <div class="layui-input-inline">
                <input autocomplete="off" lay-verify="required" class="layui-input"
                       value="${commodityPostManagementDto.mailingAddress!}">
            </div>
        </div>
    </div>-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">备注:</label>
            <div class="layui-input-inline">
                <textarea name="message" autocomplete="off" lay-verify="required" placeholder="请输入内容"
                          class="layui-input" style="width: 40%;">${commodityPostManagementDto.message!}</textarea>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">保存</button>
            <button class="layui-btn layui-btn-primary" onclick="history.back();">返回</button>
        </div>
    </div>

</form>
</body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>商品入库</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.$;

        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">

    </div>
</div>
<form method="post" name="storageFrom" id="storageFrom" class="layui-form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>订单发货</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">运单号:</label>
            <div class="layui-input-inline">
                <input name="waybillNumber" lay-verify="required" autocomplete="off" class="layui-input">
                <input name="id" autocomplete="off" class="layui-input" value="${orderId!}" type="hidden">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">快递公司:</label>
            <div class="layui-input-inline">
                <input name="expressCompany" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">发送运单信息:</label>
        <div class="layui-input-inline">
            <input type="radio" name="messageFlag" title="是" value="true" checked/>
            <input type="radio" name="messageFlag" title="否" value="false"/>
        </div>
    </div>
    <div class="layui-form-item" style="padding-left: 40%">
        <div class="layui-input-inline">
            <input class="layui-btn layui-btn-normal" lay-submit="" type="button" value="立即提交"
                   onclick="sub()"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    //提交
    function sub() {
        var waybillNumber=$(document).find("input[name='waybillNumber']").val();
        var expressompany=$(document).find("input[name='expressompany']").val();
        if(waybillNumber==''||expressompany==''){
            return;
        }
        $.ajax({
            url: 'shipment',
            type: 'get',
            data: $('#storageFrom').serialize(),
            dataType: 'json',
            success: function (result) {
                if (result.data == 'success') {
                    layer.msg('发货成功', {
                        time: 1000//0.5s后自动关闭
                    });
//                    var index = parent.layer.getFrameIndex(window.name);
//                    parent.layer.close(index);
//                    //刷新父窗口页面
//                    parent.location.reload();
                } else {
                    var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);
                    layer.msg(result.data, {
                        time: 1000//0.5s后自动关闭
                    });

                }
                setTimeout(function () {
                    parent.location.reload();
                }, 1500);
            }
        })
    }
</script>
</body>
</html>
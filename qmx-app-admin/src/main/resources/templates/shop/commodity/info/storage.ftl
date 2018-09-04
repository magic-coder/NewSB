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

            laydate.render({
                elem: "#useLife"
            });
            form.verify({
                stock: [/^\d+$/, "请填写正确的库存！"]
            });
            form.render();
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
<form name="storageFrom" id="storageFrom" class="layui-form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>商品入库</legend>
    </fieldset>
    <input name="cid" autocomplete="off" class="layui-input" value="${dto.id!}" type="hidden">
    <div class="layui-form-item" align="center">
        <div class="layui-inline">
            <label class="layui-form-label">采购数量:</label>
            <div class="layui-input-inline">
                <input name="stock" lay-verify="stock" id="stock" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item" align="center">
        <div class="layui-inline">
            <label class="layui-form-label">备注:</label>
            <div class="layui-input-inline">
                <textarea name="remark" placeholder="请输入内容" class="layui-textarea" cols="50" rows="5"></textarea>
            </div>
        </div>
    </div>
    <div class="layui-form-item" align="center">
        <div class="layui-inline">
            <label class="layui-form-label">出入库状态:</label>
            <div class="layui-input-inline">
                <input name="status" value="true" title="入库" type="radio" lay-filter="status" checked>
                <input name="status" value="false" title="出库" type="radio" lay-filter="status">
            </div>
        </div>
    </div>
    <div class="layui-form-item" align="center">
        <div class="layui-input-block">
            <input class="layui-btn layui-btn-normal" lay-submit="" value="立即提交" onclick="sub()"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    //提交
    function sub() {
        if($("input[name='status']:checked").val()=="false"){
            if($("#stock").val()>${dto.sumStock!}){
                layer.msg('出库数量大于总库存数量', {
                    time: 1000//0.5s后自动关闭
                });
                return;
            }
        }
        if(parseInt($("#stock").val())<0){
            return;
        }
        $.ajax({
            url: 'getStorage',
            type: 'post',
            data: $('#storageFrom').serialize(),
            dataType: 'json',
            success: function (result) {
                if (result.data == '1') {
                    layer.msg('操作成功', {
                        time: 500//0.5s后自动关闭
                        // btn: ['明白了', '知道了']
                    });
//                    var index = parent.layer.getFrameIndex(window.name);
//                    parent.layer.close(index);
                } else {
//                    var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);
                    layer.msg('入库失败', {
                        time: 500//0.5s后自动关闭
                        // btn: ['明白了', '知道了']
                    });
                }
                setTimeout(function () {
                    parent.location.reload();
                }, 500);
            }
        })
    }
</script>
</body>
</html>
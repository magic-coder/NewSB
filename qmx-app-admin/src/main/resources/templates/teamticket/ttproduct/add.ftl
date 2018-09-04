<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>产品-新增</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.verify({
                marketPrice: [/^[1-9]\d*\.?\d*|0\.?\d*[1-9]\d*$/, "请输入正数"]
            });

            /*form.on('radio(repairTicket)', function(){
                if($(this).val()=='true'){
                   $("div[name='marketPrice']").attr("style","display:none")
                }else {
                   $("div[name='marketPrice']").attr("style","display:block");
                }
            });*/
        });
    </script>
</head>
<body>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">

        <input type="hidden" name="repairTicket" value="false"/>
    <#--<div class="layui-inline">
        <label class="layui-form-label" style="width: auto">门票类型选择</label>
        <div class="layui-input-inline" style="width: auto">
            <input name="repairTicket" value="true" title="补价票" type="radio" lay-filter="repairTicket"/>
            <input name="repairTicket" value="false" title="常规票" type="radio" checked lay-filter="repairTicket"/>
        </div>
    </div>-->
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">产品名称</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" name="marketPrice">
            <label class="layui-form-label">门市价</label>
            <div class="layui-input-inline">
                <input name="marketPrice" lay-verify="required|marketPrice" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
    <#--<div class="layui-inline">
        <label class="layui-form-label">审核</label>
        <div class="layui-input-inline">
            <input name="audit" value="true" title="是" type="radio" checked>
            <input name="audit" value="false" title="否" type="radio">
        </div>
    </div>-->
        <div class="layui-inline">
            <label class="layui-form-label">上架</label>
            <div class="layui-input-inline">
                <input name="marketable" value="true" title="是" type="radio" checked>
                <input name="marketable" value="false" title="否" type="radio">
            </div>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">预订说明</label>
        <div class="layui-input-block">
            <textarea name="content" placeholder="预订说明" class="layui-textarea"></textarea>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>自动回复</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="save" method="post">
	<input type="hidden" name="msgTypes" value="TEXT"/>
	<input type="hidden" name="id" value="${(dto.id)!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>自动回复</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">关键字</label>
            <div class="layui-input-inline">
                <input id="keyvalue" name="keyvalue" value="${(dto.keyvalue)!}" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">自动回复内容</label>
            <div class="layui-input-inline">
                <textarea id="content" name="content" style="height:100px;width:286px;" class="bg_white-bor_grey mws_inp_1" placeholder="简介">${(dto.content)!}</textarea>
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
    <script>
        var Script = function () {
            $("#inputForm").validate({
                rules: {
                    keyvalue: "required",
                    content: "required",
                },
                messages: {
                    keyvalue: "必填项",
                    content:"必填项",
                }
            });
        }();
    </script>
</body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.verify({
                serial: [/^[1-9]\d*$/, "请填写正确的分组序号！"]
            });
        });
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">分组名称</label>
            <div class="layui-input-inline">
                <input name="gName" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.gName!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">序号</label>
            <div class="layui-input-inline">
                <input name="serial" lay-verify="serial" autocomplete="off" class="layui-input"
                       value="${dto.serial!}">
            </div>
        </div>
    </div>
    <!--组状态-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">组状态</label>
            <div class="layui-input-inline">
                <input name="status" lay-verify="required" autocomplete="off" type="radio"
                       value="true" title="启用" <#if dto.status?string("true","false")=="true">checked</#if>>
                <input name="status" lay-verify="required" autocomplete="off" type="radio"
                       value="false" title="禁用" <#if dto.status?string("true","false")=="false">checked</#if>>
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
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'laydate'], function () {
            var form = layui.form;
            var laydate = layui.laydate;
            laydate.render({
                elem: '#stime'
            });
            laydate.render({
                elem: '#etime'
            });
        });
    </script>
    <style>
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">类型</label>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required">
                    <option value=""></option>
                <#list types as type>
                    <option value="${type}" <#if type==dto.type>selected</#if>>${type.title}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">产品名称</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.name!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">成本价</label>
            <div class="layui-input-inline">
                <input name="price" lay-verify="required|number" autocomplete="off" class="layui-input"
                       value="${dto.price!}">
            </div>
        </div>
    </div>

    <div class="layui-form-item">
    <#--<div class="layui-inline">
        <label class="layui-form-label">服务标准</label>
        <div class="layui-input-inline">
            <input name="criterion" lay-verify="required" autocomplete="off" class="layui-input"
                   value="${dto.criterion!}">
        </div>
    </div>-->
        <div class="layui-inline">
            <label class="layui-form-label">服务内容</label>
            <div class="layui-input-inline">
                <textarea name="content" autocomplete="off" class="layui-input"
                          style="width: 537px;height: 127px;">${dto.content!}</textarea>
            </div>
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
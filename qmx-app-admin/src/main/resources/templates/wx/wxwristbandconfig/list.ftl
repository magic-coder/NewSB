<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>
<body>
<#include "../wxwristband/tab.ftl"/>
<form class="layui-form" action="saveconfig" method="post">
    <input type="hidden" name="id" value="${config.id!}"/>
    <input type="hidden" name="token" value="${token}" />
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 150px;">是否需要姓名：</label>
            <div class="layui-input-inline" style="width: 60%;">
                <label><input name="name" type="radio" value="true" title="是" <#if config.name> checked="checked" </#if>/></label>
                <label><input name="name" type="radio" value="false" title="否" <#if !config.name> checked="checked" </#if>/></label>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 150px;">是否需要手机号码：</label>
            <div class="layui-input-inline" style="width: 60%;">
                <label><input name="phone" type="radio" value="true" title="是" <#if config.phone> checked="checked" </#if>/></label>
                <label><input name="phone" type="radio" value="false" title="否" <#if !config.phone> checked="checked" </#if>/></label>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 150px;">是否需要身份证：</label>
            <div class="layui-input-inline" style="width: 60%;">
                <label><input name="idcard" type="radio" value="true" title="是" <#if config.idcard> checked="checked" </#if>/></label>
                <label><input name="idcard" type="radio" value="false" title="否" <#if !config.idcard> checked="checked" </#if>/></label>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
        </div>
    </div>
</form>
</body>
</html>
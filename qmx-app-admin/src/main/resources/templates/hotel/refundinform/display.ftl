<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>查看审核通知</legend>
</fieldset>
<form id="saveForm" action="update.jhtml" method="post" class="layui-form">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">通知类型</label>
            <div class="layui-form-mid">${dto.informType.type!}</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">通知方式</label>
            <div class="layui-input-block">
            <#list way as info>
                <input type="checkbox" name="way" id="way" value="${info!}"
                       <#if dto.informWay?contains(info)>checked</#if> disabled/>${info.type!}
            </#list>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">通知人(员工)</label>
            <div class="layui-form-mid">${dto.employeeName!}</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <input type="button" class="layui-btn" value="返回" onclick="history.back();"/>
        </div>
    </div>
</form>
</body>
</html>
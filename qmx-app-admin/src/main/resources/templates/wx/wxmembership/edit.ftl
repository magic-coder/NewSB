<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加模块</title>
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
<form class="layui-form" action="update" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <input type="hidden" name="id" value="${dto.id!}"/>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">卡号:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="cardNum" disabled="true" value="${dto.cardNum!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">卡类型:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="carType" disabled="true" value="<#if dto.carType=='senior'>高级会员<#else>普通会员</#if>" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">名字:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="userName" value="${dto.userName!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">电话:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="phone" disabled="true" value="${dto.phone!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">标题:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="title" value="${dto.title!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">余额:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="balance" disabled="true" value="${dto.balance!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label" style="width: 120px;">积分:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="integral" disabled="true" value="${dto.integral!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
            </div>
            <label class="layui-form-label" style="width: 120px;">备注:</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="remarks" value="${dto.remarks!}" style="display: inline;width: 190px;" autocomplete="off" class="layui-input">
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
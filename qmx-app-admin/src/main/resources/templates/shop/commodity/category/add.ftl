<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>商品品类-新增</title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${base}/bak/js/jquery.lSelect.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script src="${base}/resources/common/js/jquery-migrate-1.2.1.js"></script>
    <script>
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.$;
            form.render();
            form.verify({
                serialNumber:[/^\d+$/,"请填写正确的序号！"]
            })

            $("#account1").dropqtable({
                vinputid: "supplierFlag", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "/commodity/category/getSpecialSupplier", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierFlag").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account1").val(supplier.account);
                    }
                }
            });
            $("#account2").dropqtable({
                vinputid: "supplierId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "/commodity/category/getSupplier", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierId").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account2").val(supplier.account);
                    }
                }
            });
            $("#account3").dropqtable({
                vinputid: "supplierId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "/commodity/category/getSupplier", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierId").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account3").val(supplier.account);
                    }
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
<div class="path main">
    <div class="con_head bg_deepblue">

    </div>
</div>
<form id="commodityForm" method="post" name="imgForm" action="save" class="layui-form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">品类名称:</label>
            <div class="layui-input-inline">
                <input name="categoryName" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
<@shiro.hasPermission name="selectSupplierFlag">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">选择供应商:</label>
            <div class="layui-input-inline">
                <input type="hidden" id="supplierFlag" name="supplierFlag"/>
                <input type="hidden" id="username" name="username"/>
                <input name="account" id="account1" autocomplete="off" class="layui-input"
                       placeholder="选择主供应商">
            </div>
            <div class="layui-input-inline">
                <input type="hidden" id="supplierId" name="supplierId"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input name="account" id="account2" autocomplete="off" class="layui-input"
                       placeholder="选择关联供应商">
            </div>
        </div>
    </div>
</@shiro.hasPermission>
<@shiro.hasPermission name="selectSupplier">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">选择供应商:</label>
            <div class="layui-input-inline">
                <input type="hidden" id="supplierId" name="supplierId"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input name="account" id="account3" autocomplete="off" class="layui-input"
                       placeholder="选择关联供应商">
            </div>
        </div>
    </div>
</@shiro.hasPermission>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">序号:</label>
            <div class="layui-input-inline">
                <input name="serialNumber" lay-verify="serialNumber" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">提交</button>
            <input class="layui-btn layui-btn-primary" style="width: 80px" onclick="history.back();"  value="返回"/>
        </div>
    </div>
</form>
</body>
</html>
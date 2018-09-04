<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/resources/common/js/jquery-migrate-1.2.1.js"></script>
</head>
<body>
&nbsp;
<form class="layui-form" action="add" method="get">
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">选择旅行社</label>
        <div class="layui-input-inline">
            <input type="hidden" id="travelAgencyId" name="travelAgencyId"/>
            <input name="account" id="account" lay-verify="required" autocomplete="off" class="layui-input"
                   placeholder="选择旅行社">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
<script>
    layui.use(['form', 'table', 'laydate', 'jquery'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var $ = layui.jquery;


        $("#account").dropqtable({
            vinputid: "account", //值所存放的区域
            dropwidth: "auto", //下拉层的宽度
            selecteditem: {text: "", value: ""}, //默认值
            editable: false,
            tableoptions: {
                autoload: true,
                url: "getDistributors", //查询响应的地址
                qtitletext: "请输入旅行社id", //查询框的默认文字
                textField: 'trueName',
                valueField: 'tName',
                colmodel: [
                    {name: "id", displayname: "旅行社id", width: "150px"},
                    // {name: "account", displayname: "分销商账号", width: "100px"},
                    {name: "tName", displayname: "旅行社名称", width: "100px"}//表格定义
                ],
                onSelect: function (rules) {
                    $("#travelAgencyId").val(rules.id);
                    //$("#username").val(rules.username);
                    //$("#bookings").val(rules.ruleName);
                    $("#account").html(rules.tName);
                }
            }
        });
    });
</script>
</html>
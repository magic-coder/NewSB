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
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;


            $("#account").dropqtable({
                vinputid: "employeeId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "listProductAuthorizeJson", //查询响应的地址
                    qtitletext: "请输入员工名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "员工账号", width: "100px"},
                        {name: "username", displayname: "员工姓名", width: "100px"}//表格定义
                    ],
                    onSelect: function (employee) {
                        $("#employee").val(employee.id);
                        $("#username").val(employee.username);
                        $("#account").val(employee.account);
                    }
                }
            });
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>添加审核通知</legend>
</fieldset>
<form id="saveForm" action="save.jhtml" method="post" class="layui-form">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">通知类型</label>
            <div class="layui-input-inline">
                <select name="informType" class="layui-input">
                <#list type as info>
                    <option value="${info!}">${info.type!}</option>
                </#list>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">通知方式</label>
            <div class="layui-input-block">
            <#list way as info>
                <input type="checkbox" lay-skin="primary" title="${info.type!}" name="informWay" id="way"
                       value="${info!}"/>
            </#list>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">通知人(员工)</label>
            <div class="layui-input-inline">
                <input type="hidden" id="employee" name="employee"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input id="account" class="layui-input" name="account"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input type="button" class="layui-btn" value="返回" onclick="history.back();"/>

        </div>
    </div>
</form>
</body>
</html>
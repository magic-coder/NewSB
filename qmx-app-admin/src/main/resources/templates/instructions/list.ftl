<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${base}/bak/resources/layui/css/layui.css" media="all">
    <script src="${base}/bak/resources/layui/layui.js" charset="utf-8"></script>
    <style type="text/css">
        .layui-form {
            margin-left: 100px
        }
    </style>

<#--<script type="text/javascript">-->
<#--function keyLogin() {-->
<#--if (event.keyCode == 13)  //回车键的键值为13-->
<#--document.getElementById("chaxun").click(); //调用登录按钮的登录事件-->
<#--}-->
<#--</script>-->
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
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>使用说明列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="keyword" value="${dto.keyword!}" autocomplete="off"
                       class="layui-input" placeholder="请输入查询的编号或标题">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>

<#--<div class="layui-form-item">-->
<#--<div class="layui-inline">-->
<#--<div class="layui-input-inline">-->
<#--<button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>-->
<#--</div>-->
<#--</div>-->
<#--</div>-->
<table class="layui-table" style="width:80%;margin-left: 95px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <tr>
        <th>
            说明编号
        </th>
        <th>
            说明标题
        </th>
        <th>
            操作
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td>
        ${dto.serial}
        </td>
        <td>
        ${dto.title}
        </td>
        <td>
            <input type="button" onclick="location.href='getdetails?id=${dto.detailsId!?c}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                   value="查看"/>
            <#--<input type="button" onclick="del('${dto.id?c}')" class="layui-btn layui-btn-normal layui-btn-sm"-->
                   <#--data-id="${dto.id!}" id="viewBtn"-->
                   <#--value="删除"/>-->
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        layer.confirm(msg, {title: "会员删除确认"}, function () {
            window.location.href = "delete.jhtml?id=" + id;
        })

    }
</script>
</body>
</html>
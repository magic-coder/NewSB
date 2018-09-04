<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'element'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>供应商列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">供应商账号</label>
            <div class="layui-input-inline">
                <input type="text" name="account" value="${dto.account!}" autocomplete="off"
                       class="layui-input">
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

<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable">
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            供应商账号
        </th>
        <th>
            联系电话
        </th>
        <th>
            创建时间
        </th>
        <th>
            操作
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" class="checkboxes" name="ids" value="${dto.id!}"/>
           <#-- <input name="id" type="checkbox" value="${dto.id?c!}"/>-->
        </td>
        <td>
        ${dto.account!}
        </td>
        <td>
        ${dto.phone!}
        </td>
        <td>
        ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td>
            <input type="button" class="btn layui-btn layui-btn-normal"
                   data-clipboard-text="${url!}/binding/info/index?userId=${dto.id?c!}"
                   value="复制链接"/>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
<script src="${base}/resources/common/js/clipboard.min.js"></script>

<script>
    var clipboard = new ClipboardJS('.btn');

    clipboard.on('success', function (e) {
        layer.msg("复制成功！");
    });

    clipboard.on('error', function (e) {
        layer.msg("复制失败！");
    });
</script>
</body>
</html>
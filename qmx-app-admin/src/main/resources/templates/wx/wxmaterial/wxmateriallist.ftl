<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
    <script>
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
        //提交iframe
        $(document).on("click", "#submitIframe", function () {
            var $checkedId = $("input[name='ids']:enabled:checked");
            parent.$("#mediaId").val($checkedId.val());
            parent.$("#mediaId").val($checkedId.parents("tr:eq(0)").find("td:eq(1)").text());
            parent.layer.close(index);
        });
    </script>
</head>
<body>
<hr/>
<form class="layui-form" action="wxmateriallist" method="post">
    <input type="hidden" name="type" value="${type!}"/>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <tr>
        <th class="check" style="text-align: center">
        </th>
        <th style="text-align: center">
            媒体文件ID
        </th>
        <th style="text-align: center">
            标题
        </th>
        <th style="text-align: center">
            摘要
        </th>
        <th style="text-align: center">
            <span>操作</span>
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td style="text-align: center">
            <input type="radio" name="ids" value="${dto.id}"/>
        </td>
        <td style="text-align: center">${dto.mediaId!}</td>
        <#if type=="NEWS">
            <td style="text-align: center">${dto.title!}</td>
            <td style="text-align: center">${dto.digest!}</td>
            <td style="text-align: center">
                <a class="fg_blue" href="${dto.url!}" target="_blank">阅读原文</a>
            </td>
        </#if>
        <#if type=="IMAGE">
            <td style="text-align: center">${dto.name!}</td>
            <td style="text-align: center"><#if dto.updateTime??>${dto.updateTime?string("yyyy-MM-dd HH:mm:ss")}</#if></td>
            <td style="text-align: center">
                <a class="fg_blue" href="${dto.url!'javascript:void(0);'}" target="_blank">查看</a>
            </td>
        </#if>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
<div class="layui-form-item">
    <div align="center">
        <div>
            <input id="submitIframe" type="button" class="layui-btn layui-btn-normal" value="确定"/>
            <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
        </div>
    </div>
</div>
</body>
</html>
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
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>页面列表</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="NEWS">class="layui-this"</#if>><a href="list?type=NEWS">图文消息</a></li>
        <li <#if type=="IMAGE">class="layui-this"</#if>><a href="list?type=IMAGE">图片库</a></li>
    </ul>
</div>
<form class="layui-form" action="list" method="post">
    <input id="type" type="hidden" name="type" value="${type!}"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">名称</label>
            <div class="layui-input-inline">
                <input type="text" name="title" value="${dto.title!}" autocomplete="off"
                       class="layui-input" placeholder="标题">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list?type=<#if type=="IMAGE">IMAGE<#else>NEWS</#if>';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button id="synchroButton" class="layui-btn layui-btn-normal">同步素材</button>
        </div>
    </div>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <tr>
        <th class="check" style="text-align: center">
            <input type="checkbox" id="selectAll"/>
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
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
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

<script type="text/javascript">
    var $synchroButton = $("#synchroButton");
    var ok = true;
    $synchroButton.click(function () {
        var type = $("#type").val();
        if (type == "IMAGE") {
            type = "image";
        } else if (type == "VOICE") {
            type = "voice";
        } else if (type == "VIDEO") {
            type = "video";
        } else if (type == "NEWS") {
            type = "news";
        }
        if (ok) {
            ok = false;
            $.ajax({
                url: "synchro",
                type: "POST",
                data: "type=" + type,
                dataType: "json",
                cache: false,
                success: function (info) {
                    ok = true;
                    if (info == 0) {
                        setTimeout(function () {
                            location.reload(true);
                        }, 1000);
                        alert("同步成功！");
                    } else {
                        alert("同步失败！");
                    }
                }
            });
        } else {
            alert("同步中，请稍等。。。");
        }
    });
</script>
</body>
</html>
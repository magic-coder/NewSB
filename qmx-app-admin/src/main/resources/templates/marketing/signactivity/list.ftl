<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <script type="text/javascript" src="${base}/resources/module/wx/js/showDialog.js"></script>
    <link rel="stylesheet" href="${base}/bak/css/wx/showDialog.css" />
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
        //删除
        $(document).on("click", "#deleteBtn", function () {
            var data = $(this).attr("data-id");
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function () {
                $.ajax({
                    url: "delete",
                    type: "POST",
                    data: {id: data},
                    beforeSend: function () {
                    },
                    success: function (json) {
                        if (json.state == "success") {
                            layer.msg(json.msg);
                            setTimeout(function () {
                                location.reload(true);
                            }, 500);
                        } else {
                            layer.msg(json.msg);
                        }
                    }
                });
            }, function () {

            });
        });
    </script>
</head>
<body>
<#include "tab.ftl"/>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">活动名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
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

<div class="layui-form-item" style="margin-left: 10px;">
<@shiro.hasPermission name = "wxturntable:add">
    <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
</@shiro.hasPermission>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>活动名称</th>
        <th>活动时间</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
        ${dto.name!}
        </td>
        <td>
        ${dto.startDate!?string("yyyy-MM-dd")}至${dto.endDate!?string("yyyy-MM-dd")}
        </td>
        <td>
            <input style="width: 80px;" id="copy${dto_index}" class="layui-btn layui-btn-normal layui-btn-sm copy"
                   title="${siteUrl}/wxSignIndex?id=${dto.id!?c}" value="复制链接">
            <input style="width: 80px;" onclick="showqrcode('${siteUrl!}/wxSignIndex?id=${dto.id!?c}')" class="layui-btn layui-btn-normal layui-btn-sm"
                   value="预览">
            <@shiro.hasPermission name = "wxturntable:edit">
                <input type="button" onclick="location.href='edit?id=${dto.id!}';"
                       class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="editBtn"
                       value="编辑"/>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "wxturntable:delete">
                <input type="button" class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}" id="deleteBtn"
                       value="删除"/>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>

    </tbody>
</table>
<#include "/include/my_pagination.ftl">
<script type="text/javascript" src="${base}/bak/js/ZeroClipboard.js"></script>
<script type="text/javascript">
    function showqrcode(url){
        $.ajax({
            type: "post",
            url: "../wxutils/getqrcode?url="+url,
            success: function(msg){
                showInfo("<img src='"+msg+"' />");
            }
        });
    }
    $(function () {
        $(".copy").each(function () {
            var Zero = ZeroClipboard;
            Zero.moviePath = "${base}/resources/module/shop/swf/ZeroClipboard.swf";

            var clip = new ZeroClipboard.Client();
            clip.setHandCursor(true);
            var obj = $(this);
            var id = $(this).attr("id");
            clip.glue(id);

            var txt = $("#" + id).attr("title");//设置文本框中的内容

            //鼠标移上时改变按钮的样式
            clip.addEventListener("mouseOver", function (client) {
                obj.css("color", "#000000");
                clip.setText(txt);
            });
            //鼠标移除时改变按钮的样式
            clip.addEventListener("mouseOut", function (client) {
                obj.css("color", "");
            });
            //这个是复制成功后的提示
            clip.addEventListener("complete", function () {
                alert("已经复制到剪切板！\n" + txt);
            });
        });
    });
</script>
</body>
</html>
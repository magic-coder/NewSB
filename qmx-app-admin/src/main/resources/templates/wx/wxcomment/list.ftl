<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>评论管理</title>
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
    <legend>评论列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">昵称</label>
            <div class="layui-input-inline">
                <input type="text" name="nickname" value="${dto.nickname!}" autocomplete="off"
                       class="layui-input" placeholder="昵称">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button id="copy" title="${siteUrl!}/wxcomment?id=${aid!}" type="reset" class="layui-btn layui-btn-normal copy bor_grey">复制链接</button>
            </div>
        </div>
    </div>
</form>
    <table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
           lay-size="sm" lay-filter="sysBalanceTableEvent">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll"/>
            </th>
            <th>
                粉丝昵称
            </th>
            <th>
                姓名
            </th>
            <th>
                电话
            </th>
            <th>
                时间
            </th>
            <th>
                状态
            </th>
            <th>
                操作
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td style="text-align: center">
                <input name="id" type="checkbox" value="${(dto.id)!}"/>
            </td>
            <td style="text-align: center">
            ${(dto.nickname)!}
            </td>
            <td style="text-align: center">
            ${(dto.name)!}
            </td>
            <td style="text-align: center">
            ${(dto.phone)!}
            </td>
            <td style="text-align: center">
            ${dto.createTime?string("yyyy-MM-dd HH:mm:ss")}
            </td>
            <td style="text-align: center">
                <#if dto.isReply??&&dto.isReply==true>
                    <font color="green">已回复</font>
                <#else>
                    <font color="red" title="">未回复</font>
                </#if>
            </td>
            <td style="text-align: center">
                <input type="button" onclick="location.href='add?id=${dto.id!?c}&isReply=${(dto.isReply?c)!}&isUserMessage=${(dto.isUserMessage?c)!}&userId=${(dto.userId)!}';"
                       class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                       value="回复"/>
                <input type="button" onclick="del('${dto.id?c}')" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                       value="删除"/>
            </td>
        </tr>
    </#list>
    </table>
<#include "/include/my_pagination.ftl">
<script type="text/javascript" src="${base}/bak/js/ZeroClipboard.js"></script>
<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg)==true){
            window.location.href="delete.jhtml?id="+id;
        }else{
            return false;
        }
    }
    $(document).ready(function(){
        $("button.copy").each(function(){
            var Zero = ZeroClipboard;
            Zero.moviePath = "${base}/resources/module/shop/swf/ZeroClipboard.swf";

            var clip = new ZeroClipboard.Client();
            clip.setHandCursor(true);
            var obj = $(this);
            var id = $(this).attr("id");
            clip.glue(id);

            var txt=$("#"+id).attr("title");//设置文本框中的内容

            //鼠标移上时改变按钮的样式
            clip.addEventListener( "mouseOver", function(client) {
                obj.css("color","#FF6600");
                clip.setText(txt);
            });
            //鼠标移除时改变按钮的样式
            clip.addEventListener( "mouseOut", function(client) {
                obj.css("color","");
            });
            //这个是复制成功后的提示
            clip.addEventListener( "complete", function(){
                alert("已经复制到剪切板！\n"+txt);
            });
        });
    });
</script>
</body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>语音导游列表</title>
    <script type="text/javascript" src="${base}/resources/module/wx/js/showDialog.js"></script>
    <link rel="stylesheet" href="${base}/bak/css/wx/showDialog.css" />
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
    <legend>语音导游列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">名称</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input" placeholder="请输入名称">
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
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
        </div>
    </div>
</div>
    <table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
           lay-size="sm" lay-filter="sysBalanceTableEvent">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll"/>
            </th>
            <th>
                名称
            </th>
            <th>
                sw
            </th>
            <th>
                ne
            </th>
            <th>
               二维码
            </th>
            <th>
                <span>操作</span>
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td style="text-align: center">
                <input type="checkbox" name="ids" value="${dto.id}"/>
            </td>
            <td style="text-align: center">
            ${(dto.name)!}
            </td>
            <td style="text-align: center">
            ${(dto.swCenter)!}
            </td>
            <td style="text-align: center">
            ${(dto.neCenter)!}
            </td>
            <td style="text-align: center">
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm copy" id="copy${dto.id!}" title="${siteUrl!}/wxmapvoice?id=${dto.id!?c}" value="复制地址"/>
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" onclick="showqrcode('${siteUrl!}/wxmapvoice?id=${dto.id!?c}')" value="预览"/>
            </td>
            <td style="text-align: center">
                <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                       class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                       value="编辑"/>
                <input type="button" onclick="del('${dto.id!?c}')" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                       value="删除"/>
            </td>
        </tr>
    </#list>
    </table>
<#include "/include/my_pagination.ftl">


<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg)==true){
            alert(id);
            window.location.href="delete.jhtml?id="+id;
        }else{
            return false;
        }
    }
    function showqrcode(url){
        $.ajax({
            type: "post",
            url: "../wxutils/getqrcode?url="+url,
            success: function(msg){
                showInfo("<img src='"+msg+"' />");
            }
        });
    }
</script>
<script type="text/javascript" src="/bak/js/ZeroClipboard.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $("input.copy").each(function(){

            var Zero = ZeroClipboard;
            Zero.moviePath = "/resources/module/shop/swf/ZeroClipboard.swf";

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
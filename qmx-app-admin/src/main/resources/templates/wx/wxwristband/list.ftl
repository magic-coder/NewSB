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
<#include "tab.ftl"/>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">条码号</label>
            <div class="layui-input-inline">
                <input type="text" name="barCode" value="${dto.barCode!}" autocomplete="off"
                       class="layui-input" placeholder="请输入条码号">
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
                <button id="copy" title="${siteUrl!}/wdczindex?id=${aid!}" type="reset" class="layui-btn layui-btn-normal copy bor_grey">复制链接</button>
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
                GUID
            </th>
            <th>
                腕带条码
            </th>
            <th>
                票类型
            </th>
            <th>
                状态
            </th>
            <th>
                有效期开始
            </th>
            <th>
                有效期截止
            </th>
            <th>
                当前余额
            </th>
            <th>
                备注说明
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td>
                <input type="checkbox" name="ids" value="${dto.id!}"/>
            </td>
            <td>
            ${dto.guId!}
            </td>
            <td>
            ${dto.barCode!}
            </td>
            <td>
            ${dto.wdType!}
            </td>
            <td>
                <#if dto.enable==true>
                    <span style="color:green;">√</span>
                <#else>
                    <span style="color:red;">×</span>
                </#if>
            </td>
            <td>
            ${dto.vStart!}
            </td>
            <td>
            ${dto.vEnd!}
            </td>
            <td>
                <span style="color:red;">￥${dto.balance!}</span>
            </td>
            <td>
            ${dto.remarks!}
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
</form>

</body>
</html>
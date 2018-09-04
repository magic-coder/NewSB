<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/css/bootstrap.min.css"/>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            laydate.render({
                elem: '#startTime', //指定元素
                type: 'datetime'
            });
            laydate.render({
                elem: '#endTime', //指定元素
                type: 'datetime'
            });
            form.render();

        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>日志列表</legend>
</fieldset>
<form id="listForm" class="layui-form" action="logList" method="get">
    <input type="hidden" name="rid" value="${dto.rid!}"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">时间段:</label>
            <div class="layui-input-inline">
                <input name="startTime" id="startTime"
                       autocomplete="off" class="layui-input" value="${dto.startTime!}">
            </div>
            <div class="layui-input-inline">
                <input name="endTime" id="endTime"
                       autocomplete="off" class="layui-input" value="${dto.endTime!}">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='logList?rid=${dto.rid!}';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>

<table id="listTable" class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th>
            操作类型
        </th>
        <th>
            操作内容
        </th>
        <th>
            修改数据
        </th>
        <th>
            操作人
        </th>
        <th>
            操作时间
        </th>
    </tr>
    </thead>
<#list page.records as dto>
    <tr>
        <td>
        ${dto.type!}
        </td>
        <td>
        ${dto.content!}
        </td>
        <td>
        ${dto.modifyAfter!}
        </td>
        <td>
        ${dto.createName!}
        </td>
        <td>
        ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">


<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            window.location.href = "delete.jhtml?id=" + id;
        } else {
            return false;
        }
    }
</script>
<script type="text/javascript">
    //下架
    function soldOut() {
        if ($(".checkboxes:checked").length < 1) {
            alert('请选择一件商品');
            return;
        }
        if ($(".checkboxes:checked").length > 1) {
            alert('只能选择一件商品');
            return;
        }
        var id = $("input[name='ids']:checked").val();
        window.location.href = "/commodityRelease/sold?commodityReleaseId=" + id;
    }
    //上架
    function putAway() {
        if ($(".checkboxes:checked").length < 1) {
            alert('请选择一件商品');
            return;
        }
        if ($(".checkboxes:checked").length > 1) {
            alert('只能选择一件商品');
            return;
        }
        var id = $("input[name='ids']:checked").val();
        window.location.href = "/commodityRelease/putAway?commodityReleaseId=" + id;
    }

    //全选
    $('#selectAll').click(function () {
        // do something
        if ($("#selectAll").attr("checked")) {
            $("input[name='ids']").attr("checked", true);
        } else {
            $("input[name='ids']").attr("checked", false);
        }
    })
</script>
<#--消息提示框-->
<style>
    #tip {
        position: absolute;
        top: 85px;
        left: 50%;
        display: none;
        z-index: 9999;
        color: red;
        font-size: 20px;
    }
</style>
<strong id="tip"></strong>
<script>
    //tip是提示信息，type:'success'是成功信息，'danger'是失败信息,'info'是普通信息,'warning'是警告信息
    function showTip(tip, type) {
        var $tip = $('#tip');
        $tip.stop(true).prop('class', 'alert alert-' + type).text(tip).css('margin-left', -$tip.outerWidth() / 2).fadeIn(500).delay(2000).fadeOut(500);
    }

    var Script = function () {
    <#if msg??>
        showTip("${msg}", "success");
    </#if>
    }();
</script>
</body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>房型列表</title>
<#include "/include/common_header_include.ftl">

<#--<link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
<link href="${base}/bak/css/bootstrap.min.css"/>
<script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>-->
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
    <legend>房型列表</legend>
</fieldset>
<form action="getList" method="get" class="layui-form">
    <input type="hidden" placeholder="酒店id" name="hid" value="${dto.hid!}"/>
    <div class="layui-form-item" style="margin-left: 10px;">
    <#--<input type="text" placeholder="房型名称" name="name" value="${dto.name!}"/>
    <input type="text" placeholder="楼层" name="floor" value="${dto.floor!}"/>
    <input type="text" placeholder="床型" name="bedType" value="${dto.bedType!}"/>
    <input type="text" placeholder="床宽" name="bedSize" value="${dto.bedSize!}"/>
    <input type="text" placeholder="最大入住人数" name="maxOccupancy" value="${dto.maxOccupancy!}"/>-->
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input" placeholder="房型名称">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="floor" value="${dto.floor!}" autocomplete="off"
                       class="layui-input" placeholder="楼层">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="bedType" value="${dto.bedType!}" autocomplete="off"
                       class="layui-input" placeholder="床型">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="bedSize" value="${dto.bedSize!}" autocomplete="off"
                       class="layui-input" placeholder="床宽">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="maxOccupancy" value="${dto.maxOccupancy!}" autocomplete="off"
                       class="layui-input" placeholder="最大入住人数">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='getList.jhtml?hid=${dto.hid}';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item" style="margin-left: 10px;">
<@shiro.hasPermission name="addHotelRoom">
    <button onclick="location.href='add?hid=${dto.hid}';" class="layui-btn layui-btn-normal">添加</button>
</@shiro.hasPermission>
<@shiro.hasPermission name="deleteRoom">
    <button onclick="delAll()" class="layui-btn layui-btn-normal">删除</button>
</@shiro.hasPermission>
</div>
<table id="listTable" class="layui-table" id="listTable">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            房型名称
        </th>
        <th>
            楼层
        </th>
        <th>
            床型
        </th>
        <th>
            床宽
        </th>
        <th>
            房间面积
        </th>
        <th>
            最大入住人数
        </th>
        <th>
            创建时间
        </th>
        <th>
            创建人
        </th>
        <th>
            <span>操作</span>
        </th>
    </tr>
    </thead>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}" class="checkboxes" id="checkboxes"/>
        </td>
        <td>
        ${dto.name!}
        </td>
        <td>
        ${dto.floor!}
        </td>
        <td>
        ${dto.bedType!}
        </td>
        <td>
        ${dto.bedSize!}
        </td>
        <td>
        ${dto.area!}
        </td>
        <td>
        ${dto.maxOccupancy!}
        </td>
        <td>
        ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td>
        ${dto.createName!}
        </td>
        <td>
            <@shiro.hasPermission name="editRoom">
            <#--<a href="edit?id=${dto.id}">[编辑]</a>-->
                <input type="button" onclick="location.href='edit?id=${dto.id}';"
                       class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       value="编辑"/>
            </@shiro.hasPermission>
        <#--<a onclick="del('${dto.id?c}','${dto.hid?c}');">[删除]</a>-->
            <input type="button" onclick="location.href='addOccupy?rid=${dto.id!}&&name=${dto.name!}&&hid=${dto.hid!}';"
                   class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                   value="占用"/>
            <@shiro.hasPermission name="disPlayHotelRoom">
            <#--<a href="disPlay?id=${dto.id!}">[查看]</a>-->
                <input type="button" onclick="location.href='disPlay?id=${dto.id!}';"
                       class="layui-btn layui-btn-sm layui-btn-normal" data-id="${dto.id!}"
                       value="查看"/>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#--引人分页-->
<#include "/include/my_pagination.ftl">
<#--分页结束-->

<script type="text/javascript">
    function del(id, hid) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            window.location.href = "delete.jhtml?id=" + id + "&hid=" + hid;
        } else {
            return false;
        }
    }
</script>
<script type="text/javascript">
    function delAll() {
        if ($(".checkboxes:checked").length < 1) {
            alert('请选择一条数据');
            return;
        }
        var ids = "";
        $("input[name='ids']:checked").each(function () {//遍历选中的单选框
            var id = $(this).val();
            ids = ids + "," + id;
        });
        ids = ids.substring(1, ids.length);
        var msg = "您真的确定要删除吗?\n\n请确认！";
        if (confirm(msg) == true) {
            $.ajax({
                url: '/hotelRoomType/deleteAll',
                type: 'GET',
                async: true,
                data: {"ids": ids},
                dataType: 'json',
                success: function (result) {
                    if (result.data == "1") {
                        showTip("操作成功", "success");
                        $("input[name='ids']:checked").each(function () {//遍历选中的单选框
                            n = $(this).parents("tr").index();//获取单选框选中的所在行数
                            $("table#listTable").find("tr:eq(" + n + ")").remove();
                        });
                    } else {
                        showTip("操作失败", "danger");
                    }
                }
            });
            return true;
        } else {
            return false;
        }
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
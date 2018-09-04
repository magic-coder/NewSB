<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/css/bootstrap.min.css"/>
    <script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/common.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        模块列表
    </div>
</div>
<form id="listForm" action="imgList" method="get">
    <div class="bar">
        <br/>
        <input type="hidden" name="hid" value="${dto.hid!}"/>
        <select name="attribute">
            <option value="">图片属性</option>
        <#list attribute as info>
            <option value="${info!}" <#if '${info!}'=='${dto.attribute!}'>selected</#if>>${info.type!}</option>
        </#list>
        </select>
        <select name="type">
            <option value="">图片类型</option>
        <#list type as info>
            <option value="${info}" <#if '${info!}'=='${dto.type!}'>selected</#if>>${info.type!}</option>
        </#list>
        </select>
        <button type="submit" class="button">查询</button>
        <button type="button" class="button" onclick="location.href='imgList.jhtml?hid=${dto.hid!}';">重置</button>
        <span style="color:green;">${flash_message_attribute_name!}</span>
    </div>
    <div class="bar">
        <a href="addImg?hid=${dto.hid}" class="button">
            添加
        </a>
        <a onclick="delAll()" class="button">
            删除
        </a>
        <a class="button" href="/hotelInfo/edit?id=${dto.hid!}">
            返回
        </a>
    </div>
    <table id="listTable" class="list">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll"/>
            </th>
            <th>
                图片路径
            </th>
            <th>
                图片属性
            </th>
            <th>
                图片类型
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
    <#list page.records as dto>
        <tr>
            <td>
                <input type="checkbox" name="ids" value="${dto.id?c}" class="checkboxes"/>
            </td>
            <td>
            ${dto.url!}
            </td>
            <td>
                <#list attribute as info>
                    <#if info=='${dto.attribute!}'>
                ${info.type!}
                </#if>
                </#list>
            </td>
            <td>
                <#list type as info>
                    <#if info=='${dto.type!}'>
                ${info.type!}
                </#if>
                </#list>
            </td>
            <td>
            ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
            </td>
            <td>
            ${dto.createName!}
            </td>
            <td>
                <a href="editImg?imgId=${dto.id}">[编辑]</a>
                <a onclick="del('${dto.id?c}','${dto.hid}');">[删除]</a>
            </td>
        </tr>
    </#list>
    </table>
<#include "../../include/pagination.ftl">
</form>

<script type="text/javascript">
    function del(id, hid) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            window.location.href = "deleteImg.jhtml?imgId=" + id + "&hid=" + hid;
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
                url: '/hotelInfo/deleteImgAll',
                type: 'GET',
                async: true,
                data: {"ids": ids},
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
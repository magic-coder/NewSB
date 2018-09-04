<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
    <link href="${base}/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/css/bootstrap.min.css"/>
    <script type="text/javascript" src="${base}/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/js/list.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap-paginator.js"></script>
    <script type="text/javascript" src="${base}/js/showDialog.js"></script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        模块列表
    </div>
</div>
<form id="listForm" action="list.jhtml" method="get">
    <div class="bar">
        <br/>
        <input type="text" placeholder="活动名称" name="name" value="${dto.name!}"/>
        <select name="enable">
            <option value="">--是否启用--</option>
            <option value="1" <#if dto.enable?? && dto.enable==true>selected</#if>>启用</option>
            <option value="0" <#if dto.enable?? && dto.enable==false>selected</#if>>禁用</option>
        </select>
        <button type="submit" class="button">查询</button>
        <button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
        <span style="color:green;">${flash_message_attribute_name!}</span>
    </div>
    <div class="bar">
        &nbsp;
        <a href="add" class="button">
            添加
        </a>
    </div>
    <table id="listTable" class="list">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll"/>
            </th>
            <th>
                活动名称
            </th>
            <th>
                参与人数
            </th>
            <th>
                浏览数
            </th>
            <th>
                总投票数
            </th>
            <th>
                有效状态
            </th>
            <th>
                <span>操作</span>
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td>
                <input type="checkbox" name="ids" value="${dto.id}"/>
            </td>
            <td>
                ${dto.name!}
            </td>
            <td>
                ${dto.number!}
            </td>
            <td>
                ${dto.browse!}
            </td>
            <td>
                ${dto.totalVote!}
            </td>
            <td>
                <#if dto.enable>
                    <span style="color:green;">√</span>
                <#else>
                    <span style="color:red;">×</span>
                </#if>
            </td>
            <td>
                <a href="edit?id=${dto.id}">[编辑]</a>
                <a class="del" onclick="del('${dto.id?c}');">[删除]</a>
                <a class="bor_grey del" onclick="showqrcode('www.baidu.com');">[预览]</a>
            </td>
        </tr>
    </#list>
    </table>
<#include "../../include/pagination.ftl">
</form>

<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg)==true){
            window.location.href="delete.jhtml?id="+id;
        }else{
            return false;
        }
    }

    function showqrcode(url){
        $.ajax({
            type: "post",
            url: "getqrcode?url="+url,
            success: function(msg){
                showInfo("<img src='"+msg+"' />");
            }
        });
    }

</script>
</body>
</html>
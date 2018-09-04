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
        <input type="text" placeholder="授权方appid" name="authorizerAppid" value="${dto.authorizerAppid!}"/>
        <input type="text" placeholder="授权方昵称" name="nickName" value="${dto.nickName!}"/>
        <select name="enable">
            <option value="">--是否启用--</option>
            <option value="true">启用</option>
            <option value="false">禁用</option>
        </select>
        <button type="submit" class="button">查询</button>
        <button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
        <span style="color:green;">${flash_message_attribute_name!}</span>
    </div>
    <div class="bar">
        &nbsp;
    <@shiro.hasPermission name = "admin:addDistributor">
        <a href="add.jhtml" class="button">
            添加普通分销
        </a>
    </@shiro.hasPermission>
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
                授权方appid
            </th>
            <th>
                授权方昵称
            </th>
            <th>
                原始ID
            </th>
            <th>
                GDS secretKey
            </th>
            <th>
                是否启用
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
            ${dto.authorizerAppid!}
            </td>
            <td>
            ${dto.nickName!}
            </td>
            <td>
            ${dto.userName!}
            </td>
            <td>
            ${dto.secretKey!}
            </td>
            <td>

            </td>
            <td>
                <a href="${componentloginpage}">[授权]</a>
                <a href="xuanze?id=${dto.id}">[选择]</a>
                <a href="edit?id=${dto.id}">[编辑]</a>
                <a onclick="del('${dto.id?c}');">[删除]</a>
            </td>
        </tr>
    </#list>
    </table>
<#include "../../include/pagination.ftl">
</form>

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
</body>
</html>
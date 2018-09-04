<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>列表</title>
<#include "/include/header_include_old.ftl">
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        列表
    </div>
</div>
<form id="listForm" action="list" method="get">
    <div class="bar">
        <br/>
        <select name="moduleId">
            <option value="">--选择平台--</option>
            <#list payPlats as payPlat>
                <option <#if queryDto.payPlat?? && payPlat == queryDto.payPlat>selected</#if> value="${payPlat!}">${payPlat.getName()}</option>
            </#list>
        </select>
        渠道名称：<input name="channelName" value="${queryDto.channelName!}"/>
        <button type="submit" class="button">查询</button>
        <button type="button" class="button" onclick="location.href='list';">重置</button>
    </div>
    <div class="bar">
    <@shiro.hasPermission name = "admin:addPayChannel">
        <a href="add" class="button">添加</a>
    </@shiro.hasPermission>
    </div>
    <table id="listTable" class="list">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll" />
            </th>
            <th>
                渠道名称
            </th>
            <th>
                渠道标识
            </th>
            <th>
                平台
            </th>
            <th>添加时间</th>
            <th>
                <span>操作</span>
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td>
                <input type="checkbox" name="ids" value="${dto.id}" />
            </td>
            <td>
            ${dto.channelName!'-'}
            </td>
            <td>
            ${dto.channelNo!'-'}
            </td>
            <td>
                <#if dto.payPlat??>
                    ${dto.payPlat.getName()}
                </#if>
            </td>
            <td>${dto.createTime?string("yyyy-MM-dd HH:mm:ss")}</td>
            <td>
                <@shiro.hasPermission name = "admin:editPayChannel">
                    <a href="edit?id=${dto.id}">[编辑]</a>
                </@shiro.hasPermission>
            </td>
        </tr>
    </#list>
    </table>
<#include "/include/pagination.ftl">
</form>
</body>
</html>